var websocket;
var utente;
var ros;
var pub_text;
var sub_text;
var sub_img;
const SpeechRecognition = window.SpeechRecognition || webkitSpeechRecognition;
const SpeechGrammarList = window.SpeechGrammarList || webkitSpeechGrammarList;

var recognition;
var speechRecognitionList;
var synth = window.speechSynthesis;;
var voices;
var speaker;

function log(who, str) {
    if(who.split(":")[0] == "Robot"){
        speaker.text= str;
        synth.speak(speaker);
    }
    $("#output").val(who+str + "\n" + $("#output").val());
}

function pub_msg(text) {
    var msg = new ROSLIB.Message({
        data: text
    });
    pub_text.publish(msg);
}

function setup_ros() {

    ros = new ROSLIB.Ros({
        url: websocket
    });

    ros.on('connection', () => {
        log("System: ",'Connection with the robot established.');
    });

    ros.on('error', (error) => {
        log("System: ",'Connection error with the robot.', error);
        // close_connection();
    });

    ros.on('close', () => {
        log("System: ",'Connection with the robot has been closed.');
        // close_connection();
    });

    // pub_obiettivo = new ROSLIB.Topic({
    //     ros: ros,
    //     name: '/obiettivo',
    //     messageType: 'dr_ped/Obiettivo'
    // });

    pub_text = new ROSLIB.Topic({
        ros: ros,
        name: '/text_speech',
        messageType: 'std_msgs/String'
    });

    sub_text = new ROSLIB.Topic({
        ros: ros,
        name: '/logger_web',
        messageType: 'std_msgs/String'
    });

    sub_img = new ROSLIB.Topic({
        ros : ros,
        name : '/camera/rgb/image_raw_3',
        messageType : 'sensor_msgs/CompressedImage'
    });

    sub_text.subscribe(function (text) {
        log("Robot: ", text.data);
    });
    
    // Define a callback function to handle the incoming image data
    sub_img.subscribe(function(msg) {
        var img = new Image();
        img.src = "data:image/jpeg;base64," + msg.data;

        // When the image is loaded, draw it on a canvas element
        img.onload = function() {
            // Create a canvas element and set its dimensions to match the image
            var canvas = document.getElementById('canvas_img');    
            // Get the 2D context of the canvas and draw the image on it
            var ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0);
        }
    });
    
}

function setup_recognition() {
    const grammar = "#JSGF V1.0";
    recognition = new SpeechRecognition();
    speechRecognitionList = new SpeechGrammarList();
    speechRecognitionList.addFromString(grammar, 1);
    recognition.grammars = speechRecognitionList;
    // recognition.lang = 'it-IT';
    recognition.lang = 'en-US';
    recognition.interimResults = false;

    recognition.onresult = function (event) {
        var last = event.results.length - 1;
        var command = event.results[last][0].transcript.toLowerCase();
        log(utente.split(":")[0] + ": ", command);
        pub_msg(command);
    };

    recognition.onspeechend = function () {
        recognition.stop();
    };

    recognition.onerror = function (event) {
        log("System: ",'Error occurred in recognition: ' + event.error);
    }
}

function setup_speaker(){
    // set the voice to use (optional)
    voices = synth.getVoices();
    // create a new SpeechSynthesisUtterance object
    speaker = new SpeechSynthesisUtterance();
    speaker.voice = voices[3];
}

//ip = "10.10.247.106"
ip = "192.168.1.57" // or location.hostname

$(document).ready(() => {

    $("#login").on('click', () => {
        var nome = $("#nome").val();
        var pw = $("#password").val();
        // if (!nome || !pw) {
        //     alert("insert name and password");
        //     return;
        // }
        if (["dennis:30","marco:10","fabio:20"].includes(nome.toLowerCase()+":"+pw))
            $("#welcome").html("Welcome back " + nome);
        else
            $("#welcome").html("Welcome " + nome+", first time here?");
        utente = nome + ":" + pw;
        $("#persona").addClass("invisibile");
        $("#controllo").removeClass("invisibile");

        setup_recognition();
        setup_speaker();
        // here we assume that the rosbrige is on our machine
        // otherwise is enough to change the ip
        websocket = "ws://" + ip + ":9090"; //to have a url
        setup_ros(); //connect to ros
    });

    $("#speak").on('click', () => {
        recognition.start();
        log("System: ", "Ready to receive a voice command.");
    });

    $("#objects").on('click', (event) => {
        console.log(event.target);
        var obj = $(event.target).attr("id");
        var action = $(event.target).text();
        log("Robot: ", "ok so you want me to " + action);
        pub_msg(obj);
    });

    $("#movements").on('click', (event) => {
        console.log(event.target);
        var obj = $(event.target).attr("id");
        if(obj === "speak")
            return
        log("Robot: ", "ok so you want me to " + obj);

        pub_msg(obj);
    });

    $("#input_text").keypress(function(event) {
        // console.log(event);
        // log("me",event.keyCode);
        var key = (event.keyCode ? event.keyCode : event.which);
        if (key === 13 || key === 'Enter') {
            event.preventDefault();
            msg = $("#input_text").val();
            $("#input_text").val('');
            log(utente.split(":")[0]+": ",msg);
            pub_msg(msg);
        }
     });
});