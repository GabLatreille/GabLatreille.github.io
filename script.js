document.getElementById('button1').onclick = switchTheme;
document.getElementById('button2').onclick = switchTheme;

function switchTheme() {
  if (document.getElementsByTagName("div")[0].style.backgroundImage == 'url("img/lightpurple.png")') {
    document.getElementsByTagName("div")[0].style.backgroundImage = 'url("img/darkpurple.png")';
    document.getElementsByTagName("span")[0].style.backgroundImage = 'url("img/lightpurple.png")';
    document.getElementsByTagName("span")[1].style.backgroundImage = 'url("img/lightpurple.png")';
  } else {
    document.getElementsByTagName("div")[0].style.backgroundImage = 'url("img/lightpurple.png")';
    document.getElementsByTagName("span")[0].style.backgroundImage = 'url("img/darkpurple.png")';
    document.getElementsByTagName("span")[1].style.backgroundImage = 'url("img/darkpurple.png")';
  }
}
