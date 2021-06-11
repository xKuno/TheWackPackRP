var animating = false;
var usingvoice = false;
var usingid = false;
var usingstress = false;

function toggleMapUI(visable) {

    if (visable) {
        $(".outline").fadeIn();
        $(".speed").fadeIn();
    } else {
        $(".outline").fadeOut();
        $(".speed").fadeOut();
    }

}


function changeProgress(progress, element) {


    var changed = Math.round(130 - (progress * 1.2));
    var element = $(element).find(".progress")


    if (String(Math.round(parseInt(element[0].style.top))).replace("%", "") != String(changed) && !animating) {
        animating = true;

        element.animate({
            top: changed + '%'

        }, 500, "swing", function () {
            animating = false;

        });
    }


}

$(document).ready(function () {

    $("#main_container").hide();
});

window.addEventListener('message', function (event) {


    var edata = event.data;

    if (edata.type == "Init") {


        $("#main_container").show();

        if (!edata.showid) {
            $("#u229").addClass("hidden");
        } else {
            usingid = true;
        }

        if (edata.showstress) {
            usingstress = true;
        }
        if (edata.showvoice) {
            usingvoice = true;
        }


        $(".health").find(".logo").addClass(edata.healthIcon);
        $(".armor").find(".logo").addClass(edata.armorIcon);
        $(".food").find(".logo").addClass(edata.foodIcon);
        $(".thirst").find(".logo").addClass(edata.thirstIcon);
        $(".fourth").find(".logo").addClass(edata.fourthIcon);

    } else if (edata.type == "changeStatus") {


        changeProgress(edata.health, ".health");
        changeProgress(edata.armor, ".armor");
        changeProgress(edata.food, ".food");
        changeProgress(edata.thirst, ".thirst");

        if (usingid) {
            $("#u229").text(edata.id);
        } else if (usingstress) {
            changeProgress(edata.stress, ".fourth");
        } else if (usingvoice) {
            changeProgress(edata.voice, ".fourth");
        }


    } else if (edata.type == "closeMapUI") {
        toggleMapUI(false);
    } else if (edata.type == "openMapUI") {
        toggleMapUI(true);
    } else if (edata.type == "hideUI") {
        $("#main_container").hide();
    } else if (edata.type == "showUI") {
        $("#main_container").show();
    } else if (edata.type == "toggleTalking") {
        if (edata.talking && usingvoice) {
            $(".fourth").find(".logo").css("color", "#6F6F6F");
        } else {
            $(".fourth").find(".logo").css("color", "white");
        }
    }


});