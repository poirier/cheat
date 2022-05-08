Go Webserver
============

Web server function (can run as goroutine)::

    func Webserver(address string) {
        logger.Printf("Starting webserver at %s\n", address)

        activeHandler := ActiveHandler{ args }

        http.Handle("/bin/", http.StripPrefix("/bin", activeHandler))
        http.Handle("/static/", http.StripPrefix("/static", staticHandler))
        http.Handle("/", templateHandler)
        err := http.ListenAndServe(address, nil)
        if err != nil {
            panic(err)
        }
    }


Handler to serve some embedded static files::

    var (
        //go:embed something.js
        somethingjs []byte
        //go:embed image.png
        image_png []byte
    )
    type StaticHandler struct {
        urlToPage map[string]StaticPage
    }

    type StaticPage struct {
        bits        []byte
        contentType string
    }

    var staticHandler = StaticHandler{
        urlToPage: map[string]StaticPage{
            "/something.js":         {somethingjs, "application/javascript"},
            "/image.png": {image_png, "image/png"},
        },
    }

    func (h StaticHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
        //logger.Printf("StaticHandler.ServeHTTP('%v')\n", req.URL.Path)
        page, ok := h.urlToPage[req.URL.Path]
        if ok {
            w.Header().Set("content-type", page.contentType)
            _, err := w.Write(page.bits)
            if err != nil {
                logger.Print(err)
            }
        } else {
            logger.Printf("StaticHandler.ServeHTTP('%v') => 404\n", req.URL.Path)
            http.NotFound(w, req)
        }
    }



Return data as JSON::

    func ReturnDataAsJSON(w http.ResponseWriter, data any) {
        jsonData := misc.ToJSON(data)
        w.Header().Add(http.CanonicalHeaderKey("content-type"), "application/json")
        w.WriteHeader(http.StatusOK)
        _, err := w.Write(jsonData)
        misc.Check(err)
    }
