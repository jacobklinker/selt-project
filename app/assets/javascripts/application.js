// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

function clearPick(game) {
    var match = "picks[game"+game+"]"
    var buttons = document.getElementsByName(match);
    
    for(var i=0;i<buttons.length;i++)
      buttons[i].checked = false;
      
    radioCount();
}

function radioCount(){
    var inputs = document.getElementsByTagName("*");
    var radios = [];
    var count = 0;
    
    for (var i = 0; i < inputs.length; ++i) {
        if (inputs[i].type == 'radio') {
            radios.push(inputs[i]);
        }
    }
    
    for(var i=0;i<radios.length;i++){
        if(radios[i].checked){
            count++;
        }
    }
    
    if(count == 10){
        for(var i=0;i<radios.length;i++){
            if(radios[i].checked == false){
                radios[i].disabled = true;
            }
        }
    }
    else{
        for(var i=0;i<radios.length;i++){
            if(radios[i].checked == false){
                radios[i].disabled = false;
            }
        }
    }
}