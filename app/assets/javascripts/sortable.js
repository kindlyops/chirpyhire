App.Sortable = {
  onMoveUpdateNumber: function(e) {
    var draggedDiv = $(e.dragged).find(".sortable-number")[0],
      relatedDiv = $(e.related).find(".sortable-number")[0],
      draggedNumber = draggedDiv.textContent;
    draggedDiv.textContent = relatedDiv.textContent;
    relatedDiv.textContent = draggedNumber;
  },
  handle: ".drag-and-drop"
}
