/* eslint-disable no-unused-vars */

// Side navigation
function w3_open() {
    let x = document.getElementById('mySidebar');
    x.style.width = '100%';
    x.style.fontSize = '40px';
    x.style.paddingTop = '10%';
    x.style.display = 'block';
}
function w3_close() {
    document.getElementById('mySidebar').style.display = 'none';
}

// Tabs
function openCity(evt, cityName) {
    let i;
    let x = document.getElementsByClassName('city');
    for (i = 0; i < x.length; i++) {
        x[i].style.display = 'none';
    }
    let activebtn = document.getElementsByClassName('testbtn');
    for (i = 0; i < x.length; i++) {
        activebtn[i].className = activebtn[i].className.replace(' w3-dark-grey', '');
    }
    document.getElementById(cityName).style.display = 'block';
    evt.currentTarget.className += ' w3-dark-grey';
}

let mybtn = document.getElementsByClassName('testbtn')[0];
mybtn.click();

// Accordions
function myAccFunc(id) {
    let x = document.getElementById(id);
    if (x.className.indexOf('w3-show') == -1) {
        x.className += ' w3-show';
    } else {
        x.className = x.className.replace(' w3-show', '');
    }
}

// Slideshows
let slideIndex = 1;

function plusDivs(n) {
    slideIndex = slideIndex + n;
    showDivs(slideIndex);
}

function showDivs(n) {
    let x = document.getElementsByClassName('mySlides');
    if (n > x.length) {
        slideIndex = 1;
    }
    if (n < 1) {
        slideIndex = x.length;
    }
    for (i = 0; i < x.length; i++) {
        x[i].style.display = 'none';
    }
    x[slideIndex - 1].style.display = 'block';
}

showDivs(1);

// Progress Bars
function move() {
    let elem = document.getElementById('myBar');
    let width = 5;
    let id = setInterval(frame, 10);
    function frame() {
        if (width == 100) {
            clearInterval(id);
        } else {
            width++;
            elem.style.width = `${width}%`;
            elem.innerHTML = `${width * 1}%`;
        }
    }
}

// Custom logic for the Lambda Test dialog
$('#envName').text(`Welcome to the ${window._config.envName} environment of`);
$('#pApiUrl').text(`API URL: ${_config.apiUrl}`);
$('#btnTestNodeHelloLambda').click(() => handleApiClick('hello-node'));
$('#btnTestNodeLotteryLambda').click(() => handleApiClick('lottery-node'));
$('#btnTestPythonHelloLambda').click(() => handleApiClick('hello-python'));
$('#btnClearLambdaOutput').click(() => setOutput());

$('#btnLambdaDialogOpen').click(() => {
    setOutput();
    $('#dlgLambdaDialog').css('display', 'block');
});

$('#btnDialogClose').click(() => {
    setOutput();
    $('#dlgLambdaDialog').css('display', 'none');
});

function handleApiClick(endpoint) {
    const pSpinner = $('#pSpinner');

    pSpinner.show();

    $.get(`${_config.apiUrl}/${endpoint}`, data => {
        const message = data.message.text ? data.message.text : data.message;

        setOutput(message);

        pSpinner.hide();
    });
}

function setOutput(message) {
    const txtLambdaOuput = $('#txtLambdaOuput');

    txtLambdaOuput.val(message || '');
}
