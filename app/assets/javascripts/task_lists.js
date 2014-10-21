function TaskList(task_list) {
	if (!task_list) {
		if (!App().task_list) {
			App().task_list = new TaskList($('.task-list.selected'));
		}
		return App().task_list;
	}

	var tasks = task_list.find(".tasks"),
		popups = $('.task-popups'),
		nextTaskPopup = popups.find(".task-solved-popup"),
		listDonePopup = popups.find(".task-list-solved-popup"),
		closeBtns = popups.find(".close-btn"),
		okBtns = popups.find(".next-link"),
		$this = this;

	closeBtns.click(closePopup);
	okBtns.click(okClick);
	$(window).keydown(onKeyDown);

	$this.selectedTask = tasks.find("li.selected");
	$this.nextTask = $this.selectedTask.next();

	if ($this.nextTask.length == 0) {
		var taskItems = tasks.find("li");
		var taskCount = taskItems.length;
		for (var i = 0; i < taskCount; i++)
			if ($(taskItems[i]).data('done') == 0 && !$(taskItems[i]).hasClass('selected')) {
				$this.nextTask = $(taskItems[i]);
				break;
			}
	}

	$this.nextTaskUrl = $this.nextTask.find("a").attr("href");
	$this.popupShown = false;

	this.markSelectedDone = function() {
		$this.selectedTask.data('done', 1);
		$this.selectedTask.find('.done').addClass('visible');
	}

	this.moveForward = function() {
		hideAllPopups();
		if (this.nextTask.length > 0)
			showNextTaskPopup();
		else
			showListDonePopup();
		$this.popupShown = true;
	}

	function showNextTaskPopup() {
		nextTaskPopup.css('display', 'block');
		$this.ok = moveToNextTask;
		showPopupArea();
	}

	function showListDonePopup() {
		listDonePopup.css('display', 'block');
		$this.ok = closePopup;
		showPopupArea();
	}

	function hideAllPopups() {
		nextTaskPopup.css('display', 'none');
		listDonePopup.css('display', 'none');
	}

	function showPopupArea() {
		popups.css('opacity', 0).css('display', 'block').animate({opacity: 1}, 400);
	}

	function closePopup() {
		if (!$this.popupShown)
			return;
		popups.animate({opacity:0}, 400, function () { popups.css('display', 'none')});
		$this.popupShown = false;
	}

	function moveToNextTask() {
		window.open($this.nextTaskUrl, "_self");
	}

	function okClick(e) {
		if (e)
			e.preventDefault();
		if ($this.ok)
			$this.ok();
	}

	function onKeyDown(e) {
		if (!$this.popupShown)
			return;
		if (e.keyCode == 27)
			closePopup();
		if (e.keyCode == 13)
			okClick(e);
	}

	this.init = function () {}
}

$(function () {
	TaskList().init();
})
