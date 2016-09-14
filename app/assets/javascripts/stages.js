$(document).on("turbolinks:load", function() {
	var wrapper = $(".stages-wrapper");
	if(wrapper.find(".stage").length) {
		var stagesList = wrapper.find(".stages")[0];
		new Sortable(stagesList, {
			handle: ".stage",
			animation: 125,
			chosenClass: "sortable-chosen",
			ghostClass: "sortable-ghost",
			onMove: function(e) {
				var draggedDiv = $(e.dragged).find(".order")[0],
					relatedDiv = $(e.related).find(".order")[0],
					draggedNumber = draggedDiv.textContent;
				draggedDiv.textContent = relatedDiv.textContent;
				relatedDiv.textContent = draggedNumber;
			},
			onUpdate: function(e) {
				var $questions = $(e.to);
				// TODO JLW POST
				console.log(e);
			}
		});
	};
});