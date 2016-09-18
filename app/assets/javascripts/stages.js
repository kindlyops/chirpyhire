$(document).on("turbolinks:load", function() {
	var wrapper = $(".stages-wrapper"),
		setupSorting = function() {
			if(wrapper.find(".stage").length) {
				var stagesList = wrapper.find(".stages"),
					stagesListElement = stagesList[0];
				new Sortable(stagesListElement, {
					handle: ".stage",
					animation: 125,
					chosenClass: "sortable-chosen",
					ghostClass: "sortable-ghost",
					onMove: App.Sortable.onMoveUpdateNumber,
					onUpdate: function(e) {
						stagesList.find(".stage").each(function(i, stageItem) {
							$(stageItem).find(".hidden-order").val(i + 1);
						});
					}
				});
			};
		};

	setupSorting();
});
