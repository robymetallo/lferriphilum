package main

import (
	"bufio"
	"compress/bzip2"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"

	"gonum.org/v1/gonum/stat"
)

func main() {
	var data []float64
	re := regexp.MustCompile(`(?im)length=\d+$`)
	inputFile := os.Args[1]
	f, err := os.Open(inputFile)
	if err != nil {
		log.Fatal(err)
	}

	s := bufio.NewScanner(bzip2.NewReader(f))
	for s.Scan() {
		line := s.Text()
		if err := s.Err(); err != nil {
			log.Fatal(err)
		}
		if length := re.FindString(line); length != "" {
			n, err := strconv.ParseFloat(length[7:len(length)], 64)
			if err != nil {
				log.Fatal(err)
			}
			data = append(data, n)
		}
	}
	w := make([]float64, len(data))
	for i := range w {
		w[i] = 1
	}
	modeVal, modeCount := stat.Mode(data, w)
	mean, stdDev := stat.MeanStdDev(data, w)
	fmt.Printf("Mean: %.3f\nMode: %0.f(%0.f)\nStd. Dev: %.3f\nVariance: %v\n\n",
		mean, modeVal, modeCount, stdDev, stdDev*stdDev)
}
