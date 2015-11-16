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
    if($(":radio:checked").size()==5){
        $(":radio").each(function() {
            
            var $this = $(this);
            
            if(!$this.is(":checked")){
                $this.attr('disabled', true);
            }
        })
        
        $(":radio").each(function() {
            var $this = $(this);
            if($(this).is(":checked")){
                $(":radio").each(function() {
                    if($(this).attr('name') == $this.attr('name')){
                        $(this).attr('disabled', false);
                    }
                })
            }
        })
        
        $('input[type="submit"]').prop('disabled', false);
    }
    else{
        $(":radio").each(function() {
            $(this).attr('disabled', false);
        })
        
        $('input[type="submit"]').prop('disabled', true);
    }
}