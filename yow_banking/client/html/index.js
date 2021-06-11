$(function() {
  window.addEventListener('message', function(event) {
    if (event.data.type === "openGeneral"){
              $('#log').slideDown();
              $('#log').show();
              $('body').addClass("active");
    } else if(event.data.type === "balanceHUD2") {
        $('.curbalance').html(event.data.balance);
    } else if (event.data.type === "closeAll"){
              $('#log, #log1, #deleting, #loginin, #logininatm, #createaccount, #loga, #makejob, #general, #buss, #settings, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
              $('body').removeClass("active");
    } else if (event.data.type === "succlogin"){
      $('.curbalance').html(event.data.balance);
      $('#creadits').hide();
      $('#loginin').hide();
      $('#lolboy').hide();
      $('#fontbeauty').hide();
      $('#fontbeautyy').hide();
      $('#lolboyy').hide();
      $('#transferUI').hide();
      
      
      
      $('.username1').html(event.data.player);
      $('.username12').html(event.data.player);
      $('#withdrawUI').slideDown();
      $('.debitnum').html(event.data.debitcard);
      $('.pinnum').html(event.data.pin);
      $('.accnumber').html(event.data.accNum);
      $('.accnumber').html(event.data.accNum2);
      $('#general').slideDown(400);
      $('#creadits').show(400);

    } else if (event.data.type === "succloginbus"){
      $('#creaditss').hide();
      $('.curbalance').html(event.data.balance);
      
      $('.username1').html(event.data.player);
      $('.username12').html(event.data.player);
      $('.debitnum').html(event.data.debitcard);
      $('#withdrawUI').slideDown();
      $('.pinnum').html(event.data.pin);
      $('.accnumber').html(event.data.accNum);
      $('.accnumber').html(event.data.accNum2);
      $('#makejob').hide(200);
      $('#buss').slideDown(400);
      $('#transferUI').hide();
      $('#creaditss').show(400);

    } else if (event.data.type === "openatm"){
      $('#logininatm').slideDown(400);
      $('body').addClass("active");
      

    } else if (event.data.type === "succloginatm"){
      $('#creaditatm').hide();
      $('.accnumber').html(event.data.accNum);
      $('.curbalance').html(event.data.balance);
      $('#logininatm').hide(400);
      $('body').removeClass("active");
      $('#atmopen').slideDown();
      $('.username1').html(event.data.player);
      $('.username12').html(event.data.player);
      $('.debitnum').html(event.data.debitcard);
      $('#creaditatm').show(100);
  
    } else if(event.data.type === "saymyname") {
      $('.username2').html(event.data.player);
    } else if(event.data.type === "deletedatall") {
      $('#general, #settings, #log, #deleting, #log1, #loginin, #logininatm, #createaccount, #loga, #makejob, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
      $('body').removeClass("active");
      $.post('http://yow_banking/NUIFocusOff', JSON.stringify({}));
    } else if(event.data.type === "withdone") {
      $('#withdrawUI').slideUp();
      
    } else if(event.data.type === "depodone") {
      $('#depositUI').slideUp();
      
    }	else if(event.data.type === "transdone") {
      $('#transferUI').slideUp();
      
    }	
    else if(event.data.type === "failed") {
      $('#deleting').hide();
      $('#settings').show();
    }
    else if (event.data.type === "result") {
      if (event.data.t == "success")
        $("#result").attr('class', 'alert-green');
      else
        $("#result").attr('class', 'alert-orange');
      $("#result").html(event.data.m).show().delay(5000).fadeOut();
    }
  });
});
  $('.btn-sign-out').click(function(){
        $('#general, #settings, #log, #deleting, #log1, #loginin, #logininatm, #createaccount, #makejob, #loga #transferUI, #withdrawUI, #depositUI, #topbar').slideUp();
        $('body').removeClass("active");
        $.post('http://yow_banking/NUIFocusOff', JSON.stringify({}));
    })
    $('.back').click(function(){
        $('#depositUI, #withdrawUI, #transferUI, #settings, #deleting').slideUp();
        
    })
$('.back1').click(function(){
       $("#loginin, #createaccount, #logininatm, #makejob").hide();
        
        $('#log').slideDown(600);
    })

$('.backatm').click(function(){
        $("#loginin, #createaccount, #logininatm, #makejob").hide();
        $.post('https://yow_banking/NUIFocusOff', JSON.stringify({}));
   })
    $('#deposit').click(function(){
        // $('#general').hide();
        $('#transferUI').hide();
        $('#withdrawUI').hide();
        $('#depositUI').slideDown();
    })

    $('#depositt').click(function(){
      // $('#general').hide();
      $('#transferUI').hide();
      $('#withdrawUI').hide();
      $('#depositUI').slideDown();
  })

    $('#withdraw').click(function(){
        // $('#general').hide();
        $('#depositUI').hide();
        $('#transferUI').hide();
        $('#withdrawUI').slideDown();
    })

    $('#withdraww').click(function(){
      // $('#general').hide();
      $('#depositUI').hide();
      $('#transferUI').hide();
      $('#withdrawUI').slideDown();
  })
    $('#transfer').click(function(){
        $('#creadit').hide();
        // $('#general').hide();
        $('#depositUI').hide();
        $('#withdrawUI').hide();
        $('#transferUI').slideDown();
        $('#creadit').slideDown();
    })

    $('#transferr').click(function(){
      $('#creadit').hide();
      // $('#general').hide();
      $('#depositUI').hide();
      $('#withdrawUI').hide();
      $('#transferUI').slideDown();
      $('#creadit').slideDown();
  })
$('#settbutt').click(function(){
        $('#general').hide();
        $('#settings').show();
    })
$("#logon").click(function(){
  $('#log').hide();
  $('#loginin').slideDown(1000);
})


$("#createac").click(function(){
  $('#log').hide();
  $.post('https://yow_banking/getname', JSON.stringify({}))

  $("#createaccount").slideUp();
        
  $("#createaccount").slideDown(1000);
  $('#createaccount').show();

})

$("#loginjob").click(function(){
  $('#log').hide();
  $.post('https://yow_banking/getname', JSON.stringify({}))

  $("#makejob").slideUp();
        
  $("#makejob").slideDown(1000);
  $('#makejob').show();

})

$("#login1").submit(function(e){
  e.preventDefault();
  $.post('https://yow_banking/login', JSON.stringify({
    login: $("#login").val(),
    password: $("#password").val()
  }))
})

$("#loginatmok").submit(function(e){
  e.preventDefault();
  $.post('https://yow_banking/loginatm', JSON.stringify({
    login: $("#loginatm").val(),
    password: $("#passwordatm").val()
  }))
})

$("#ohh").submit(function(e){
  e.preventDefault();
  $.post('https://yow_banking/loginbus', JSON.stringify({
    login: $("#login2").val(),
    password: $("#passwordda").val()
  }))
})
$("#create1").submit(function(e){
  e.preventDefault();
  $.post('https://yow_banking/createaccountnew', JSON.stringify({
    login12: $("#login12").val(),
    password1: $("#password1").val(),
    pin: $("#pin").val()
  }))
  $('#createaccount').slideUp();
  $('#general, #buss, #settings, #log, #log1, #deleting, #loginin, #logininatm, #atmopen, #loga, #createaccount, #makejob, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
  $('body').removeClass("active");
  $.post('https://yow_banking/NUIFocusOff', JSON.stringify({}));
})
    $("#deposit1").submit(function(e) {
      e.preventDefault();
      $.post('https://yow_banking/deposit2', JSON.stringify({
          amount: $("#amount").val()
      }));
  
  
  $("#amount").val('');
});
$("#transfer1").submit(function(e) {
      e.preventDefault();
      $.post('https://yow_banking/transfer', JSON.stringify({
    to: $("#to").val(),
          amountt: $("#amountt").val()
      }));
  $("#amountt").val('');
});
$("#withdraw1").submit(function(e) {
  e.preventDefault();
      $.post('https://yow_banking/withdrawl', JSON.stringify({
          amountw: $("#amountw").val()
      }));
  $("#amountw").val('');
});

$("#withdraw1atm").submit(function(e) {
  e.preventDefault();
      $.post('https://yow_banking/withdrawlatm', JSON.stringify({
          amountwatm: $("#amountwatm").val()
      }));
  $("#amountwatm").val('');
});

$("#withdraw2").submit(function(e) {
  e.preventDefault();
      $.post('https://yow_banking/withdrawl', JSON.stringify({
          amountw: $("#amountw").val()
      }));
  $("#amountw").val('');
});


document.onkeyup = function(data){
      if (data.which == 27){
          $('#general, #buss, #settings, #log, #log1, #deleting, #loginin, #logininatm, #atmopen, #loga, #createaccount, #makejob, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
          $('body').removeClass("active");
          $.post('https://yow_banking/NUIFocusOff', JSON.stringify({}));
      }
}