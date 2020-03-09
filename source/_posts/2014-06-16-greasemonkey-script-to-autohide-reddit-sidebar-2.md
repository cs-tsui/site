---
layout: post
title: "GreaseMonkey Script to AutoHide Reddit Sidebar"
categories:
- JavaScript
tags:
- greasemonkey
- javascript
status: publish
type: post
published: true
meta:
  geo_public: '0'
  _wpas_skip_518743: '1'
  publicize_twitter_user: tommytsunami831
  publicize_twitter_url: http://t.co/PEoyMPGFLq
  _wpas_done_518743: '1'
  _publicize_done_external: a:1:{s:7:"twitter";a:1:{i:489535806;b:1;}}
author: 
---
<p>This simple script hides the ridiculous sidebar that squishes up the content when viewing Reddit with only a small amount of screen space (e.g. half of screen or low resolution display). It only hides the sidebar when the window width is detected to be lower than half of your resolution.</p>

{% codeblock lang:javascript %}
(function () {
    // 1920 is your screen width; adjust accordingly
    var threshold = 1920 / 2;
    
    // Get sidebar div element and its original display style
    var sideBar = document.getElementsByClassName('side') [0];
    var origStyle = sideBar.style.display;
    
    // Check the window width and hide it if it's too small
    function doCheck() {
        if (window.innerWidth < threshold) {
            sideBar.style.display = 'none';
        }
        else {
            sideBar.style.display = origStyle;
        }
    }
    // Attach it the resize event
    window.addEventListener('resize', function (event) {
        doCheck();
    });
    // Run it once initially
    doCheck();
}());
{% endcodeblock %}
