function toggleBurger(source) {
  let x = document.getElementById("topnav");
  if (x.className === "topnav" && source === 0) {
    x.className += " showdropdown";
  } else {
    x.className = "topnav";
  }
}