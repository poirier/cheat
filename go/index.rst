Go programming
==============

Just some notes so far.

.. toctree::

  database
  restclient
  webserver

And some miscellaneous notes...

.. code:: go

  // string to bytes[]
  []byte("string")

  // make a Reader from a byte array
  import bytes
  ba := []byte{....}
  reader = bytes.NewReader(ba)

  // regexes
  regex := regexp.MustCompile(pattern)
  match := regex.FindString(topic)
  if match != "" {
    queueCall(sub.handler, topic, payload)
  }

  // channels

  /* A new, initialized channel value can be made using the built-in
  function make, which takes the channel type and an optional
  capacity as arguments: */

  make(chan int, 100)

Files
-----

.. code:: go

  // write a file
  data := []byte{"xxxx"}
  err := os.WriteFile("/tmp/dat1", data, 0644)

  // read a file
  var data []byte
  bytes = os.ReadFile(path string)

Arrays and Slices
-----------------

.. code:: go

  // declare array
  q := [...]int{1, 2, 3}

  // declare slice of some type
  var subscriptions = make([]subscription, 0, 5)

  /* "The built-in function make, which takes a slice type and
  parameters specifying the length and optionally the capacity.
  A slice created with make always allocates a new, hidden array
  to which the returned slice value refers." */

  // append to slice
  a = append(a, subscriptions)

Maps and Structs
----------------

.. code:: go

  // maps and structs

  // A new, empty map value is made using the built-in function make,
  // which takes the map type and an optional capacity hint as arguments:

  make(map[string]int)
  make(map[string]int, 100)
  ages := make(map[string]int) // mapping from strings to ints
  ages := map[string]int{
      "alice":   31,
      "charlie": 34,
  }
  anim := gif.GIF{LoopCount: nframes}

  // map literal
  var mapGoToWhatHomecinemaWants = map[string]string{
    "Delete": "Del",
    "LF":     "Enter",
  }

  // Declaring a struct type and adding a method to it
  type indexHandler struct {
      webAddress string
      brokerAddress string
  }
  func (*indexHandler)ServeHTTP(w http.ResponseWriter, req *http.Request) {
  }

  // struct literal (or any composite) is
  // TYPENAME{value,value,...} or
  // TYPENAME{fieldname: value, fieldname: value, ...}
  indexHandler{webAddress: "127.0.0.1", brokerAddress: "1600"}

Embed
-----

.. code:: go

  // Embedding a file
  import _ embed

  //go:embed index.html
  var indexpage []byte

Templates - using from code
---------------------------

.. code:: go

  // Using HTML templates
  import "html/template"

  tmpl, err := template.New("index").Parse(string(indexpage))
  if err != nil {
      log.Fatal("Template:", err)
  }
  data := something...
  err = tmpl.Execute(w, data)
  if err != nil {
      log.Fatal("Webserver:", err)
  }

Template language
-----------------

* https://pkg.go.dev/text/template@go1.18.1
* https://pkg.go.dev/html/template@go1.18.1

Assume the context passed in is something like::

    {
      X: 29
      Y: func (a, b int) string { ... }
      Z: []int{1, 2, 3}
    }

Then we might have a template. "pipeline" is basically an expression
or a chain of expressions.

.. code::

    <div>The value of x is {{ .X }}.</div>
    {{ /* comment */ }}
    {{ $internalvariable := 3 }}
    {{ if pipeline }} ... {{ else }} ... {{ end }}
    {{ range $index, $element := pipeline }}
       {{ /* iteration over pipeline */ }}
    {{ end }}
    {{ with pipeline }}{{ /* in here, . has the value of pipeline;
       unless pipeline's value is empty, in which case this whole
       thing disappears. */}}
    {{ end }}
    {{ call .Y 27 32 }}
    {{ index .Z 1 /* Z[1] */ }}
    {{ slice .Z 1 /* Z[1:] */ }}

Switches
--------

.. code:: go

  // Switch
  switch topic {
  case "homecinema/input":
    fmt.Printf("[input] %s\r\n", payload)
  case "homecinema/joined":
    fmt.Printf("[joined] %s\n\n", payload)
  case "homecinema/gone":
    fmt.Printf("[gone] %s\n\n", payload)
  default:
    fmt.Printf("[%s]: %s\n\n", topic, payload)
  }

HTTP
----

.. code:: go

  // HTTP GET
  res, err := http.Get(url)
  if err != nil {
    log.Fatal(err)
  }
  body, err := io.ReadAll(res.Body)
  res.Body.Close()
  if res.StatusCode > 299 {
    log.Fatalf(
      "Response failed with status code %d and body %s",
      res.StatusCode, body)
  }
  if err != nil {
    log.Fatal(err)
  }
