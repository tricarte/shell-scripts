#!/usr/bin/env -S php837-static-opcache-min -n
<?php

namespace Tricarte;

\cli_set_process_title('line_numbers');

/*
 * This whole thing equals to:
 * `wc -l file1 file2 ... | awk '{s+=$1} END {print s}'`
 * which is a lot faster than this (almost 3 times).
 */

$total = 0;

$files = \array_slice($argv, 1, \array_key_last($argv));

// /* Peak memory usage: 6M */
// foreach ($files as $file) {
//     if (is_file($file)) {
//         $content = fopen($file, 'r');
//         $current = 0;
//         while ($line = fgets($content)) {
//             $current++;
//         }
//         $total += $current;
//         fclose($content);
//     }
// }

// Not much speed difference but memory usage rises

// /* Peak memory usage: 8.5M */
// foreach ($files as $file) {
//     if (is_file($file)) {
//         $total += count(file($file));
//     }
// }

// /*
//  * Using generators
//  * Peak memory usage: 6M
//  * Almost the same as fgets
//  */
// function getLines($file) {
//     $f = fopen($file, 'r');
//     while ($line = fgets($f)) {
//         yield $line;
//     }
// }
// foreach ($files as $file) {
//     if (is_file($file)) {
//         $total += iterator_count(getLines($file));
//     }
// }

/*
 * Most memory efficient and the fastest: 4M
 * But the result may be wrong (-1)
 * https://stackoverflow.com/questions/2162497/efficiently-counting-the-number-of-lines-of-a-text-file-200mb
 */
foreach ($files as $file) {
  if (\is_file($file)) {
    $file = new \SplFileObject($file, 'r');
    $file->seek(\PHP_INT_MAX);
    $total += $file->key();
  }
}

// /* Another version of SPL above: 6M */
// foreach ($files as $file) {
//     if (is_file($file)) {
//         $content = new \SplFileObject($file);
//         while($content->valid()) $content->fgets();
//         $total += $content->key();
//     }
// }

// print "Memory: ". memory_get_peak_usage(true).PHP_EOL;
print "Total lines: $total";
