package main

import (
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"
)

// main sends a notification to a Gotify server.
//
// The arguments are:
//
//  1. The server IP address or hostname. Defaults to 192.168.0.242.
//  2. The server port. Defaults to 8588.
//  3. The notification token.
//  4. The notification title.
//  5. The notification message.
//  6. The notification priority. Defaults to 1.
//
// Example:
//
//	notify 192.168.0.242 8588 token "Hello" "This is a test" 1
func main() {
	date := time.Now().Format("Jan 02 15:04")

	server := "192.168.0.242"
	port := "8588"

	if len(os.Args) > 1 {
		server = os.Args[1]
	}

	if len(os.Args) > 2 {
		port = os.Args[2]
	}

	if len(os.Args) < 4 {
		log.Fatal("Error: Token, Title and Message are required.")
	}

	token := os.Args[3]
	title := os.Args[4]
	message := os.Args[5]
	priority := "1"

	if len(os.Args) > 6 {
		priority = os.Args[6]
	}

	if len(os.Args) > 7 {
		fmt.Printf("Usage: notify [server] [port] [token] [title] [message] [priority]")
		log.Fatal("Error: Too many arguments.")
	}

	serverURL := fmt.Sprintf("http://%s:%s/message?token=%s", server, port, token)

	fmt.Printf("Date: %s\n", date)
	fmt.Printf("Server URL: %s\n", serverURL)
	fmt.Printf("Port: %s\n", port)
	fmt.Printf("Title: %s\n", title)
	fmt.Printf("Message: %s\n", message)
	fmt.Printf("Priority: %s\n", priority)
	fmt.Println("Sending notification to Gotify server")

	form := url.Values{}
	form.Add("title", title)
	form.Add("message", fmt.Sprintf("%s - at %s", message, date))
	form.Add("priority", priority)

	resp, err := http.PostForm(serverURL, form)

	if err != nil {
		log.Fatalf("Error sending notification: %v", err)
	}

	defer resp.Body.Close()

	fmt.Printf("Response status: %s\n", resp.Status)
}
