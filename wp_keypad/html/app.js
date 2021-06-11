
var code = ''
var length = 4
$(function() {
    window.onload = (e) =>{
        window.addEventListener('message', function(event) {
            code = event.data.code
            if(event.data.length > 4 || event.data.length <= 10){
              length = event.data.length
            }
            switch (event.data.action) {
                case 'openui':
                  $('#display').text('Enter Code')
                  $('#container').fadeIn();
                  break;
                case 'closeui':
                  $('#container').fadeOut();
                  break;
                default:
                    break;
            }
        });

        $("#submit").click(function() {
            if($('#display').text() == code){
              $.post('http://wp_keypad/SubmitCode', 'true');
            }else{
              $('#display').addClass('text-red-500')
              $('#display').text('Incorrect')
            }
        });

        $("#clear").click(function() {
          $('#display').removeClass('text-red-500')
          $("#display").html('')
        });

        document.onkeyup = function(event){
            if(event.key == "Escape"){
              $('#container').fadeOut();
              $.post('http://wp_keypad/CloseUI');
            }
        };
    }
});

function add(num){
    if(isNaN($("#display").text())){
      $("#display").html('')
      $('#display').removeClass('text-red-500')
    }
    if($("#display").text().length < length){
      $("#display").text($("#display").text()+num)
    }else{
      $("#display").html('')
    }

  }