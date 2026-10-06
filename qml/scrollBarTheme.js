(function() {
    // Script που μπαίνει μέσα στο reddit.com. Δεν βασίζεται σε συγκεκριμένα
    // CSS class names, μόνο σε links και βασική συμπεριφορά της σελίδας.

    var css = `
        /* ----- Απόκρυψη scrollbar (πιο "native" εμφάνιση μέσα σε app) ----- */
        ::-webkit-scrollbar {
            -webkit-appearance: none !important;
            width: 0px !important;
            height: 0px !important;
        }

        /* ----- Animations μέσα στο Reddit ----- */
        @keyframes rd-fade-up {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: none; }
        }
        @keyframes rd-fade-in {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        /* Τα posts και τα σχόλια εμφανίζονται απαλά καθώς φορτώνουν / κάνεις scroll */
        shreddit-post, article {
            animation: rd-fade-up 0.38s cubic-bezier(0.2, 0.8, 0.2, 1) backwards;
        }
        shreddit-comment {
            animation: rd-fade-in 0.3s ease-out backwards;
        }

        /* Απαλό cross-fade όταν αλλάζει σελίδα (SPA πλοήγηση) */
        html.rd-nav body {
            animation: rd-fade-in 0.28s ease-out;
        }

        /* Feedback αφής στα κουμπιά */
        button, [role="button"] {
            transition: transform 0.12s ease, opacity 0.12s ease;
        }
        button:active, [role="button"]:active {
            transform: scale(0.94);
        }
        * { -webkit-tap-highlight-color: transparent; }

        /* Σεβασμός στη ρύθμιση "μείωση κίνησης" της συσκευής */
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation: none !important;
                transition: none !important;
            }
        }
    `;

    var node = document.createElement("style");
    node.type = "text/css";
    node.appendChild(document.createTextNode(css));
    (document.head || document.documentElement).appendChild(node);

    // ----- EDGE-SWIPE "ΠΙΣΩ" -----
    // Swipe από την αριστερή άκρη -> history.back(), αντίστοιχο με τη native
    // χειρονομία επιστροφής του Ubuntu Touch.
    function enableEdgeSwipeBack() {
        var startX = null;
        var startY = null;
        var EDGE_PX = 24;
        var MIN_DX = 60;

        document.addEventListener("touchstart", function(e) {
            if (e.touches.length !== 1) return;
            var t = e.touches[0];
            if (t.clientX <= EDGE_PX) {
                startX = t.clientX;
                startY = t.clientY;
            } else {
                startX = null;
                startY = null;
            }
        }, { passive: true });

        document.addEventListener("touchend", function(e) {
            if (startX === null) return;
            var t = e.changedTouches[0];
            var dx = t.clientX - startX;
            var dy = Math.abs(t.clientY - startY);
            if (dx > MIN_DX && dy < 60) {
                window.history.back();
            }
            startX = null;
            startY = null;
        }, { passive: true });
    }

    // Πλοήγηση από το floating μενού (καλείται από το Main.qml). Αν υπάρχει
    // το αντίστοιχο link στη σελίδα το πατάμε (αλλαγή σελίδας μέσα στην
    // εφαρμογή). Αλλιώς κάνουμε κανονική φόρτωση της διεύθυνσης.
    var paths = {
        home:    '/',
        popular: '/r/popular',
        search:  '/search',
        notifs:  '/notifications',
        submit:  '/submit'
    };

    window.__rdGo = function(key) {
        var path = paths[key];
        if (!path) return;
        var links = document.querySelectorAll('a[href]');
        for (var i = 0; i < links.length; i++) {
            var p;
            try { p = new URL(links[i].href, location.href); }
            catch (e) { continue; }
            if (p.origin !== location.origin) continue;
            var pn = p.pathname.replace(/\/+$/, '') || '/';
            if (pn === path && !p.search) {
                links[i].click();
                return;
            }
        }
        window.location.assign(path);
    };

    // ----- ΑΝΙΜΕΪΣΝ ΑΛΛΑΓΗΣ ΣΕΛΙΔΑΣ -----
    // Το Reddit αλλάζει σελίδα χωρίς πλήρες reload (history.pushState).
    // Σε κάθε αλλαγή ξαναπαίζουμε ένα σύντομο fade του body.
    function enablePageTransitions() {
        var root = document.documentElement;
        var timer = null;

        function pulse() {
            root.classList.remove("rd-nav");
            void root.offsetWidth; // επανεκκίνηση του animation
            root.classList.add("rd-nav");
            clearTimeout(timer);
            timer = setTimeout(function() { root.classList.remove("rd-nav"); }, 350);
        }

        try {
            var origPush = history.pushState;
            history.pushState = function() {
                var r = origPush.apply(this, arguments);
                pulse();
                return r;
            };
            window.addEventListener("popstate", pulse);
        } catch (e) {}
    }

    function init() {
        enableEdgeSwipeBack();
        enablePageTransitions();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
