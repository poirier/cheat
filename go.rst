Go programming
==============

Just some notes so far.

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

  // maps

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

  // struct literal
  var mapGoToWhatHomecinemaWants = map[string]string{
    "Delete": "Del",
    "LF":     "Enter",
  }

  // Embedding a file
  import _ embed

  //go:embed index.html
  var indexpage []byte

  // Declaring a struct type and adding a method to it
  type indexHandler struct {
      webAddress string
      brokerAddress string
  }
  func (*indexHandler)ServeHTTP(w http.ResponseWriter, req *http.Request) {
  }

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
