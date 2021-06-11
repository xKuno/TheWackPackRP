var resourceName = 'dzp_poker';
var stringsLanguage = 'en';
var strings;
var isInTurn = false;

if (!String.prototype.format) {
    String.prototype.format = function() {
      var args = arguments;
      return this.replace(/{(\d+)}/g, function(match, number) { 
        return typeof args[number] != 'undefined'
          ? args[number]
          : match
        ;
      });
    };
  }

$(function (){
    $("#card-one").hide();
    $("#card-two").hide();

    $("#table-card-one").hide();
    $("#table-card-two").hide();
    $("#table-card-three").hide();
    $("#table-card-four").hide();
    $("#table-card-five").hide();

    document.getElementsByTagName("BODY")[0].style.display = "none";

    function setResourceName(name){
        resourceName = name;
        return;
    }

    function setDefaultStrings(data, language){
        // var players = document.getElementsByClassName("players");
        stringsLanguage = language;
        strings = data[language]
        $('.player').each(function(i) {
            this.innerHTML = strings['player_status_title'].format(i+1) + strings['default_player_status']
        }).fadeTo(1000, 0.4);
        $('#p1').text(strings['poker_title'])
        $('#p2').text(strings['pot_title'].format(0, strings['currency']))
        $('.bet-button').html(strings[''])

        $('button').each(function(i, button){
            $(this).find('.button-label').html(strings[this.className + '_title'])
        })
        return;
    }

    function setCards(cardNum, cardId) {
        var cardElementId;
        switch (cardNum){
            case 1:
                cardElementId = "card-one";
                break;
            case 2:
                cardElementId = "card-two";
                break;
            case 3:
                cardElementId = "table-card-one";
                break;
            case 4:
                cardElementId = "table-card-two";
                break;
            case 5:
                cardElementId = "table-card-three";
                break;
            case 6:
                cardElementId = "table-card-four";
                break;
            case 7:
                cardElementId = "table-card-five";
                break;
        }

        $('#' + cardElementId).fadeIn();
        $('#' + cardElementId).css('display', 'inline')
        document.getElementById(cardElementId + "-image").src = "images/cards/cards_" + cardId + ".png";
        return;
    }

    function hideCards() {
        $('#card-one').hide();
        $('#card-two').hide();
        $('#table-card-one').hide();
        $('#table-card-two').hide();
        $('#table-card-three').hide();
        $('#table-card-four').hide();
        $('#table-card-five').hide();
        return;
    }

    function joinGame() {
        document.getElementsByTagName("BODY")[0].style.display = "block";
        return;
    }
    
    function leaveGame() {
        document.getElementsByTagName("BODY")[0].style.display = "none";
        return;
    }

    function setStatus(data) {

        if (data.updateType === 'totalStake') {
            document.getElementById("p2").innerHTML = strings['pot_title'].format(data.totalStake, strings['currency']);
        } else if (data.updateType === 'playerTurn') {
            document.getElementById("p1").innerHTML = strings['player_turn_title'].format(data.playerName.replace(/ .*/,''));
        } else if (data.updateType === 'announceWinner') {
            document.getElementById("p1").innerHTML = strings['winning_announcement'].format(data.playerName);
        }
        return;
    }

    function setBet(slot, betAmount, playerName) {
        if (betAmount == -1) {
            document.getElementById("player" + slot).innerHTML = playerName + ": " + strings['default_player_status'];
            $('#player' + slot).fadeTo(1000, 0.4);
        } else {
            document.getElementById("player" + slot).innerHTML = playerName + ": " + betAmount;
            $('#player' + slot).fadeTo(1000, 1.0);
        }
        return;
    }

    function startTurn(checkAvailabe, callAmount, moveTimer) {
        // console.log('start Turn')
        isInTurn = true
        if (checkAvailabe) {
            document.getElementById("fold-button").style.backgroundColor = "#af4c59";
            $(".check-button").find('.button-progress').css('background-color', "#4CAF50");
            $(".check-button").find('.button-label').html(strings['check-button_title']);
            buttonTimer($(".check-button"), moveTimer, $(".check-button").outerWidth());
        } else {
            document.getElementById("check-button").style.backgroundColor = "#FF8000";
            $(".check-button").find('.button-label').html(strings['call-button_title'].format(callAmount, strings['currency']));
            $(".fold-button").find('.button-progress').css('background-color', "#af4c59");
            buttonTimer($(".fold-button"), moveTimer, $(".fold-button").outerWidth());
            // document.getElementById("check-button").innerHTML = strings['call-button_title'].format(callAmount, strings['currency']);
        }
        document.getElementById("bet-button").style.backgroundColor = "#5280d6";
        
        return;
    }
    
    function buttonTimer($button, time, startWidth) {
        var start = new Date();
        var maxTime = time * 1000;
        var timeoutVal = Math.floor(maxTime/100);
        animateUpdate();
        
        function updateProgress(percentage) {
            $button.find('.button-progress').stop(true, false).animate({'width': startWidth/100*(100-percentage) + "px"}, timeoutVal)
            // $button.find('.button-progress').css("width", startWidth/100*(100-percentage) + "px");
        }
        
        function animateUpdate() {
            var now = new Date();
            var timeDiff = now.getTime() - start.getTime();
            var perc = Math.round((timeDiff/maxTime)*100);
            
            if (perc <= 100 && isInTurn) {
                // console.log('updating progress: ' + perc)
                updateProgress(perc);
                setTimeout(animateUpdate, timeoutVal);
            }
        }
    }
    
    function finishTurn() {
        document.getElementById("bet-button").style.backgroundColor = "#696969";
        document.getElementById("check-button").style.backgroundColor = "#696969";
        document.getElementById("fold-button").style.backgroundColor = "#696969";
        $(".check-button").find('.button-progress').css('background-color', "transparent");
        $(".fold-button").find('.button-progress').css('background-color', "transparent");
        $('.button-progress').css('width', '15vh');
        isInTurn = false
        return;
    }

    function revealCards(player, cardNum, cardId){
        // console.log('reveal cards ' + player + ' ' + cardNum + ' ' + cardId + '\n')
        var cardElementId;
        switch (cardNum){
            case 1:
                cardElementId = "-card-one-image";
                break;
            case 2:
                cardElementId = "-card-two-image";
                break;
        }

        document.getElementById('player' + player + cardElementId).style.opacity = '1.0';
        document.getElementById('player' + player + cardElementId).src = "images/cards/cards_" + cardId + ".png";
        return;
    }

    function unRevealCards(){
        for (let i = 1; i <= 6; i++){
            document.getElementById('player' + i + '-card-one-image').src = "images/cards/cards_0.png";
            document.getElementById('player' + i + '-card-two-image').src = "images/cards/cards_0.png";
            document.getElementById('player' + i + '-card-one-image').style.opacity = '0.0';
            document.getElementById('player' + i + '-card-two-image').style.opacity = '0.0';
        }
        return;
    }

    window.addEventListener("message", function(event) {
        var item = event.data;
        if (item.type === "setCard") {
            setCards(item.cardNum, item.cardId);
        } else if (item.type === "hideCards") {
            hideCards();
        } else if (item.type === 'joinGame') {
            joinGame();
        } else if (item.type === 'leaveGame') {
            leaveGame();
        } else if (item.type === 'startTurn') {
            startTurn(item.checkAvailable, item.callAmount, item.timer);
        } else if (item.type === 'finishTurn') {
            finishTurn();
        } else if (item.type === 'setStatus') {
            setStatus(item.data);
        } else if (item.type === 'setBet') {
            setBet(item.slot, item.betAmount, item.playerName);
        } else if (item.type === 'revealCards') {
            revealCards(item.player, item.cardNum, item.cardId);
        } else if (item.type === 'unRevealCards') {
            unRevealCards();
        } else if (item.type === 'setResourceName') {
            setResourceName(item.resourceName);
        } else if (item.type === 'setDefaultStrings') {
            setDefaultStrings(item.stringsData, item.language);
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post("http://" + resourceName + "/exit", JSON.stringify({}))
            return;
        }
    }

    $("#check-button").click(function (){
        $.post("http://" + resourceName + "/setMove", JSON.stringify({
            move: 'check'
        }))
        return;
    })

    $("#fold-button").click(function (){
        $.post("http://" + resourceName + "/setMove", JSON.stringify({
            move: 'fold'
        }))
        return;
    })

    $("#exit-button").click(function (){
        $.post("http://" + resourceName + "/setMove", JSON.stringify({
            move: 'exit'
        }))
        return;
    })

    $("#bet-button").click(function (){
        let betValue = $("#bet-amount").val()
        if (betValue.length >= 10) {
            $.post("http://" + resourceName + "/NUIerror", JSON.stringify({
                message: 'The input value is too long'
            }))
            return;
        } else if (!betValue) {
            $.post("http://" + resourceName + "/NUIerror", JSON.stringify({
                message: 'Input value is invalid'
            }))
            return;
        }
        $.post("http://" + resourceName + "/setMove", JSON.stringify({
            move: 'bet',
            betValue: betValue
        }))
        return;
    })

    $.post("http://dzp_poker/NUILoaded", JSON.stringify({}))
})
