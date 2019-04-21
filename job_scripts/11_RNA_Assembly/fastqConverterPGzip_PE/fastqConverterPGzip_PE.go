package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
	"time"

	gzip "github.com/klauspost/pgzip"
)

type cmdArgs struct {
	inputFile        string
	compressionLevel int
}

func parseArgs() cmdArgs {
	var args cmdArgs
	flag.StringVar(&args.inputFile, "input", "Null", "Path to input file")
	flag.IntVar(&args.compressionLevel, "lvl", 6, "Specify gzip compression level (0-9)")
	flag.Parse()

	return args
}

func converterSTDIO() {
	s := bufio.NewScanner(os.Stdin)
	re := regexp.MustCompile(`(^@ERR\d{7}.\d+)(.*)(\/[12])`)
	for s.Scan() {
		line := s.Text()
		if err := s.Err(); err != nil {
			log.Fatal(err)
		}
		if match := re.FindStringSubmatch(line); match != nil {
			// fmt.Println(match)
			fmt.Println(match[1] + match[3])
		} else {
			fmt.Println(line)
		}
	}
}

func converter(fileName string, compressionLevel int) {

	log.Println("Processing", fileName)
	t0 := time.Now()
	t1 := t0
	readsT := uint64(0)
	outName := strings.TrimRight(fileName, ".fastq.gz") + "_converted.fastq.gz"

	fi, err := os.Open(fileName)
	if err != nil {
		log.Fatal(err)
	}
	fo, err := os.Create(outName)
	if err != nil {
		log.Fatal(err)
	}
	defer fi.Close()
	defer fo.Close()

	gzipRaw, err := gzip.NewReader(fi)
	if err != nil {
		log.Fatal(err)
	}
	s := bufio.NewScanner(gzipRaw)
	w, err := gzip.NewWriterLevel(fo, compressionLevel)
	if err != nil {
		log.Fatal(err)
	}
	w.SetConcurrency(1e6, 2*(runtime.NumCPU()-1))
	// re := regexp.MustCompile(`^@ERR\d{7}.\d+`)
	re := regexp.MustCompile(`(^@ERR\d{7}.\d+)(.*)(\/[12])`)
	i := uint64(0)
	for s.Scan() {
		line := s.Text()
		if err := s.Err(); err != nil {
			log.Fatal(err)
		}
		// log.Println(line)
		if match := re.FindStringSubmatch(line); match != nil {
			w.Write([]byte(match[1] + match[3] + "\n"))
			i++
			if i%1e6 == 0 {
				rate := float32(i-readsT) / float32(time.Now().Sub(t1)/time.Millisecond)
				log.Printf("File: %s -> %dM reads have been converted (%.3f reads/s)\n", filepath.Base(fileName), i/1e6, 1e3*rate)
				w.Flush()
				readsT = i
				t1 = time.Now()
			}
		} else {
			w.Write([]byte(line + "\n"))
		}
	}
	w.Close()
	log.Printf("DONE processing %s: %d reads have been converted in %v\n", fileName, i, time.Now().Sub(t0).Round(time.Second))
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	re := regexp.MustCompile(`.fastq.gz`)
	args := parseArgs()
	if args.inputFile == "Null" {
		converterSTDIO()
		return
	}
	fmt.Println("Path:", args.inputFile)
	fileList, err := filepath.Glob(filepath.Join(args.inputFile, "/*.fastq.gz"))
	if err != nil {
		log.Fatal(err)
	}
	for _, fileName := range fileList {
		if re.MatchString(fileName) {
			converter(fileName, args.compressionLevel)
		}
	}
}
