package main

import (
	"context"
	"encoding/json"
	"flag"
	"log"
	"os"

	"k8s.io/client-go/kubernetes"
	"sigs.k8s.io/controller-runtime/pkg/envtest"
)

var outputPath = flag.String("output", "", "output path")

func main() {
	flag.Parse()

	if *outputPath == "" {
		log.Fatal("output flag is required")
	}

	env := &envtest.Environment{}
	conf, err := env.Start()
	if err != nil {
		log.Fatalln("Failed to start test environment", err)
	}

	defer func() {
		if err := env.Stop(); err != nil {
			log.Println("Failed to stop test environment", err)
		}
	}()

	client, err := kubernetes.NewForConfig(conf)
	if err != nil {
		log.Fatalln("Failed to create a Kubernetes client", err)
	}

	raw, err := client.RESTClient().Get().AbsPath("/openapi/v2").Do(context.Background()).Raw()
	if err != nil {
		log.Fatalln("Failed to fetch OpenAPI schema", err)
	}

	var result interface{}
	if err := json.Unmarshal(raw, &result); err != nil {
		log.Fatalln("Failed to decode OpenAPI schema", err)
	}

	content, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		log.Fatalln("Failed to encode OpenAPI schema", err)
	}

	if err := os.WriteFile(*outputPath, content, os.ModePerm); err != nil {
		log.Fatalln("Failed to write OpenAPI file", err)
	}
}
