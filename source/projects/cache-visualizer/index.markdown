---
layout: page
title: "CPU Cache Visualizer"
date: 2014-08-21 08:57
comments: true
sharing: true
footer: true
---

### Summary

A personal project that is an extension to the cache simulator I had to implement in my Computer Architecture class. The original project was a command-line based program written in Java. This project gives a way to graphical visualize cache read/write operations with a web frontend.

This page is just a simple demo of the visualizer. An arbitrary trace file is given to send read/write instructions to the cache every second, and as the operation gets carried out, the tables below gets updated with the instruction information. A green pulse is a hit, a red pulse is a miss.

<!-- JS -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<!-- <script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script> -->
<script
<script src="http://code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
<script src="/javascripts/cpu-cache-visualizer/jquery.pulse.js"></script>

<!-- CSS -->
<!-- <link href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="/stylesheets/bootstrap.custom.css" rel="stylesheet">

<style>
.container{
    width: 100%;    
}
</style>


<div id="body" class="container">

<!-- TODO  -->
<!-- Allow user to select cache parameters -->
<!-- <h2>CPU Cache Visualizer</h2> -->
<!-- <div class="form-group">
    <select class="form-control">
        <option value="LRU"> LRU </option>
    </select>
</div> -->

<!-- Show cache Parameters -->
<h3> Configuration Parameters </h3>
<table class="table table-bordered table-striped ">
    <thead>
        <td style="width: 20%">Cache Size</td>
        <td style="width: 20%">Associativity</td>
        <td style="width: 20%">Block Size</td>
        <td style="width: 20%">Write</td>
        <td style="width: 20%">Replacement</td>
    </thead>
    <tbody>
        <td id="cache_size"></td>
        <td id="associativity"></td>
        <td id="block_size"></td>
        <td id="write_policy"></td>
        <td id="replace_policy"></td>
    </tbody>
</table>


<!-- Display the latest address being processed -->
<h3> Last Memory Access </h3>
<div id="Address"></div>
<table class="table table-bordered table-striped"><!-- Add the follow class if we want condensed "table-condensed" -->
    <thead>
        <td style="width: 20%">Operation</td>
        <td style="width: 40%">Tag</td>
        <td style="width: 20%">Index</td>
        <td style="width: 20%">Block</td>
    </thead>
    <tbody>
        <td id="op"></td>
        <td id="tag"></td>
        <td id="index"></td>
        <td id="block"></td>
    </tbody>
</table>


<!-- Display table representing the cache -->
<h3> Cachelines</h3>
<div id="myTable" ></div>

</div> <!-- End container tag-->

<script src="/javascripts/cpu-cache-visualizer/gcc_trace.js"></script>
<script src="/javascripts/cpu-cache-visualizer/cache_core.js"></script>
<script src="/javascripts/cpu-cache-visualizer/ui.js"></script>
<script>

// Cache parameters
var cacheSize = 256;
var assoc = 4;
var blockSize = 8;

// var cacheSize = 8192;
// var assoc = 4;
// var blockSize = 32;

// Instantiate cache
var myCache = new Cache(cacheSize, assoc, blockSize, cacheTableUpdate);

// Update param table
cacheParameterUpdate();

// Generate the HTML table for the cache
generateCacheTable('myTable', myCache.numSets, myCache.assoc);

// Just a single test Address
// var address = "7fcd61f8";

// Access the cache
// myCache.access(parseInt(address, 16), 'w');
// myCache.access(parseInt(address, 16), 'r'); // access again (should be a hit)

var readInstrSpeed = 1000, pulseTextSpeed = 900;
var i=0;
function accessCache() {
    if (i < Instructions.length) {
        console.log(i);
        var instr = Instructions[i].split(" ");
        var op = instr[0];
        var addr = instr[1];
        myCache.access(parseInt(addr, 16), op);
        i++;
        setTimeout(accessCache, readInstrSpeed);
    }
};

accessCache();

</script>