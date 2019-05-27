package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"

	gzip "github.com/klauspost/pgzip"
)

func main() {
	f1, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	f2, err := os.Open(os.Args[2])
	if err != nil {
		log.Fatal(err)
	}
	defer f1.Close()
	defer f2.Close()

	gzipRaw1, err := gzip.NewReader(f1)
	if err != nil {
		log.Fatal(err)
	}
	gzipRaw2, err := gzip.NewReader(f2)
	if err != nil {
		log.Fatal(err)
	}
	s1 := bufio.NewScanner(gzipRaw1)
	s2 := bufio.NewScanner(gzipRaw2)
	i := uint64(0)
	j := uint64(0)
	re := regexp.MustCompile(`(^[NATGC])`)
	for s1.Scan() && s2.Scan() {
		line1 := s1.Text()
		if err := s1.Err(); err != nil {
			log.Fatal(err)
		}
		if match := re.FindStringSubmatch(line1); match == nil {
			continue
		}
		i++
		line2 := s2.Text()
		if err := s2.Err(); err != nil {
			log.Fatal(err)
		}

		if line1 != line2 {
			j++
			fmt.Printf("line %d\nread_1 = \"%s\"\nread_2 = \"%s\"\n\n", i, line1, line2)
		}
	}
	fmt.Printf("FASTQ comparison ended. Found %d different pairs of reads\n", j)
}
