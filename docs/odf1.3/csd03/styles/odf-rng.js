
/** The URL might end with a fragment identifier (starting with # sign),
    referencing to a line number or a span of line numbers! */
window.addEventListener("hashchange", function (e) { // wait with JavaScript, until DOM is available
    console.log(e);
    var fi = window.location.hash.substring(1); // fragment identifier behind the '#'
    if (fi != '') { // if fragment identifier is not empty
        if (fi.includes('-')) { // if multiple lines are being selected
            var lines = fi.split("-");
            for (var i = lines[0]; i <= lines[1]; i++) { // highlight multiple lines
                document.querySelector('tr:nth-child(' + i + ')').classList.add("highlight");
            }
            document.getElementById(lines[0]).scrollIntoView();
        } else { // if fragment identifier is a single line        
            document.querySelector('tr:nth-child(' + fi + ')').classList.add("highlight");
            document.getElementById(fi).scrollIntoView();
        }
    }
})