Go REST Client
==============

A function to help make calls to Pinboard API::

  func makeCall(command string, args []string) []byte {
    url := "https://api.pinboard.in/v1/" + command + "?format=json&auth_token=" + token
    for _, arg := range args {
      url = url + "&" + arg
    }

    resp, err := http.Get(url)
    if err != nil {
      panic(err)
    }
    if resp.StatusCode > 399 {
      panic(resp)
    }
    defer func() {
      err := resp.Body.Close()
      if err != nil {
        panic(err)
      }
    }()
    body, err := io.ReadAll(resp.Body)
    if err != nil {
      panic(err)
    }
    //fmt.Printf("response=%v\n", resp)
    //fmt.Printf("body=%s\n", body)
    return body
  }

Use that function to call the GET entry point::

  type PinboardBookmark struct {
    Href        string    `json:"href"`
    Description string    `json:"description"`
    Extended    string    `json:"extended"`
    Meta        string    `json:"meta"`
    Hash        string    `json:"hash"`
    Time        time.Time `json:"time"`
    Shared      string    `json:"shared"`
    Toread      string    `json:"toread"`
    Tags        string    `json:"tags"`
  }

  type GetResponse struct {
    Date  time.Time          `json:"date"`
    User  string             `json:"user"`
    Posts []PinboardBookmark `json:"posts"`
  }

  func Get(tags []string, url string) GetResponse { // date time.Time, , meta bool) {
    var args []string

    if tags != nil && len(tags) > 0 {
      if len(tags) > 3 {
        panic("Max 3 tags in a call")
      }
      tagstring := strings.Join(tags, " ")
      args = append(args, "tags="+tagstring)
    }
    if url != "" {
      args = append(args, "url="+url)
    }

    /* date  UTC date in this format: 2010-12-11. */
    /* url can be nil */
    /* tags can be 0-length or nil */
    body := makeCall("posts/recent", args)
    err := os.WriteFile("response_get.json", body, 0644)
    if err != nil {
      panic(err)
    }
    var response GetResponse
    err = json.Unmarshal(body, &response)
    if err != nil {
      panic(err)
    }
    return response
  }
