var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	lineNumbers: true,
	styleActiveLine: true,
	matchBrackets: true,
	mode: "text/x-ruby",
	theme: "monokai",
	keyMap: "sublime",
	lineWrapping: true,
	extraKeys:  {
		"F11": function(cm) {
			cm.setOption("fullScreen", !cm.getOption("fullScreen"));
		},
		"Esc": function(cm) {
			if(cm.getOption("fullScreen")) {
				cm.setOption("fullScreen", false);
			}
		},
		"F8": function(cm) {
			if(cm.getOption('size')) {
				editor.setSize('auto', 'auto');
				cm.setOption("size", false);
			} else {
				editor.setSize('auto', 440);;
				cm.setOption("size", true);
			}
		}
	},
});
editor.setOption('size',true);

