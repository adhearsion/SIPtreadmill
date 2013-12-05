$(document).ready(function() {
	navResponse();
})

$(window).resize(function() {
	navResponse();
})

function navResponse() {
	if ($(window).width() < 980) {
		// Display sidebar along the top.
		$('ul.nav-collapse-primary').css('height','auto');
		$('ul.nav-collapse-primary li').css('display', 'inline-block');
		$('ul.nav-collapse-primary li > span.glow').css('display', 'none');
		$('ul.nav-collapse-primary li.active a').css('color', '#ccc');
	} else {
		// Put it back the way it was.
		$('ul.nav-collapse-primary').css('height','inherit');
		$('ul.nav-collapse-primary li > span.glow').css('display', 'block');
		$('ul.nav-collapse-primary li').css('display', 'inherit');
		$('ul.nav-collapse-primary li.active a').css('color', '#939ea4');
	}
}