$(document).on("turbolinks:load", function() {
  var wrapper = $(".stages-wrapper"),
    setupSorting = function() {
      if(wrapper.find(".stage").length) {
        var stagesList = wrapper.find(".stages"),
          reorderForm = wrapper.find(".reorder-form"),
          stagesListElement = stagesList[0];
        new Sortable(stagesListElement, {
          handle: App.Sortable.handle,
          animation: 125,
          chosenClass: "sortable-chosen",
          ghostClass: "sortable-ghost",
          onMove: App.Sortable.onMoveUpdateNumber,
          onUpdate: function(e) {
            stagesList.find(".stage").each(function(i, stageItem) {
              reorderForm.find("input.hidden-order[name='" + $(stageItem).attr("data-id") + "']").val(i + 1);
            });
          }
        });
      };
    };

  setupSorting();
});
