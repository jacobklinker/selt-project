function clearPick(game) {
    var match = "picks["+game+"]"
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