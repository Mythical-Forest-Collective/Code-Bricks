"use strict";
if (jQuery.browser.mobile) {
  $('head').append('<script src="scripts/dragndroppolyfill.js"></script>');
}

var validChars = 'abcdefghijklmnopqrstuvwxyz';
var validCharsLen = validChars.length;

function makeId() {
  var result = '';
  for ( var i = 0; i < 5; i++ ) {
      result += validChars.charAt(Math.floor(Math.random() * validCharsLen));
  }
  return result;
}

var walls = [];
var bricks = {};

function uniqueIdGen() {
  var unid = makeId();

  var uniqueId = false;
  while (!uniqueId) {
    if (!(unid in walls.map(w => w.id)) || !(bricks.keys().contains(unid))) {
      uniqueId = true;
    } else {
      unid = makeId();
    }
  }

  return unid;
}

// It creates a wall of bricks, that allow for easy separation and joining of bricks into one group
function createBrick(data = {version:1,name:"python::builtin::print",arguments:{text:"string"},generated_output:"print(<text>)",displayed:["print", "[text]"],head:-1,foot:-1,innerbrickcount:0,innerbricks:[]}) {
  const wallId = uniqueIdGen();

  var brick = document.createElement('div');
  var wall = {version: 1, id: wallId, bricks: []};

  const brickId = uniqueIdGen();

  brick.id = brickId;

  wall.bricks.push(brickId);
  data.id = brickId
  bricks[brickId] = data;

  walls.push(wall);

  brick.draggable = true;

  brick.classList.add("brick");
  brick.classList.add("laidbrick");

  $('#bricklayer').append(brick);

  var toDisplay = "";
  for (var tx in data.displayed) {
    if (tx.startsWith('[') && tx.endsWith(']')) {
      if (data.arguments.contains(tx.substr(1, str.length-1))) {
        toDisplay += "<div class=\"variable\"></div>";
      } else {
        toDisplay += tx;
      }
      if (data.displayed.indexOf(tx) != data.displayed.length) {
        toDisplay += ' ';
      }
    }
  }

  brick.innerHTML = toDisplay;
}

//#region Event Handling
addEventListener('dragstart', (event) => {
  if (!event.target.classList.contains("brick")) {
    return;
  }

  event.target.style.opacity = 0.4;
});

addEventListener('dragend', (event) => {
  // Fixes the bug where elements that aren't draggable, can be dragged and then disappear
  if (!event.target.classList.contains("brick")) {
    return;
  }

  event.target.style.transform = `translate(${event.pageX}px, ${event.pageY-$('#navbar').height()}px)`;
  event.target.style.opacity = 1;
});

addEventListener('keydown', (event) => {
  if (event.key == "q" && !event.repeat) {
    console.log("Made a new block");
    createBrick()
  }
});
//#endregion

function load() {
  createBrick()
}