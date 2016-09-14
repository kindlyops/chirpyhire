$(document).on("turbolinks:load", function() {
	var wrapper = $(".stages-wrapper"),
		getOrderData = function() {
			var mapped_stages = wrapper.find(".stage").map(function(i) {
				return { id: $(this).attr("data-id"), order: i + 1}
			}).toArray();
			return { 
				stages: mapped_stages
			};
		},
		bindUI = function() {
			wrapper.find(".save-order-button").on("click", function() {
				$.post({
					url: "/stages/reorder",
					data: JSON.stringify(getOrderData()),
					contentType: "application/json; charset=utf-8"
				});
			});
			wrapper.find(".delete-stage").on("click", function(e) {
				var stage = $(this);
				if(!stage.hasClass("disabled")) {
					$.ajax({
						url: "/stages/" + stage.attr("data-id"),
						type: "DELETE"
					})
				}
			});
		},
		setupSorting = function() {
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
		};

	bindUI()
	setupSorting()
});