function MSSQLTask(task) {
	if (!task) {
		if (!App().task) {
			App().task = new MSSQLTask($('.mssql-task'));
		}
		return App().task;
	}

	var solution = task.find('.solution-text textarea'),
		submitArea = task.find('.submit-area'),
		submit = submitArea.find('input[type=submit]'),
		alert = submitArea.find('.alert'),
		notice = submitArea.find('.notice'),
		submitAction = task.find('.solution-form').attr('action'),
		resultTable = task.find('.result-table'),
		resultLegend = task.find('.result-legend'),
		resultLegendMissingColumn = resultLegend.find('th.missing'),
		resultLegendExtraColumn = resultLegend.find('th.extra'),
		resultLegendMissingRow = resultLegend.find('tr.missing'),
		resultLegendExtraRow = resultLegend.find('tr.extra'),
		$this = this,
		orderKey = task.data('order-key'),
		ordered = task.data('ordered'),
		ldistinct = task.data('distinct');

	submit.click(sendSolution);
	solution.keydown(solutionKeyDown);
	$(window).resize(updateResultTableSize);

	this.focusSolution = function() {
		solution.focus();
	}

	function updateResultTableSize() {
		var resultArea = $('.mssql-task-result'),
			resultTable = $('.result-table'),
			legendTable = $('.result-legend');
		var maxWidth;
		if (legendTable.css('display') == 'block' ||
			legendTable.css('display') == 'inline-block')
			maxWidth = resultArea.width() - legendTable.width() - 36;
		else
			maxWidth = resultArea.width() - 20;
		var minWidth = 0;
		if ($('.result-table table'))
			minWidth = $('.result-table table').width() + getScrollBarWidth() + 1;
		if (minWidth < maxWidth)
  			resultTable.css('width', minWidth);
		else
  			resultTable.css('width', maxWidth);
	}

	function getScrollBarWidth () {
		var inner = document.createElement('p');
		inner.style.width = "100%";
		inner.style.height = "200px";

		var outer = document.createElement('div');
		outer.style.position = "absolute";
		outer.style.top = "0px";
		outer.style.left = "0px";
		outer.style.visibility = "hidden";
		outer.style.width = "200px";
		outer.style.height = "150px";
		outer.style.overflow = "hidden";
		outer.appendChild (inner);

		document.body.appendChild (outer);
		var w1 = inner.offsetWidth;
		outer.style.overflow = 'scroll';
		var w2 = inner.offsetWidth;
		if (w1 == w2) w2 = outer.clientWidth;

		document.body.removeChild (outer);

		return (w1 - w2);
	};

	function sendSolution(e) {
		if (e)
			e.preventDefault();
		submit.attr('disabled', 'disabled').addClass('progress');
		solution.attr('disabled', 'disabled');
		fadeOut(resultTable, function () { resultTable.html("") });
		fadeOut(resultLegend);
		fadeOut(alert);
		fadeOut(notice);
		console.log(submitAction);
		$.post(submitAction, { query: solution.val(), format: 'json' })
			.done(parseResponse)
			.fail(sendFailed);
	}

	function parseResponse(result) {
		console.log(result);
		if (result.error_message) {
			alert.text(result.error_message);
			fadeIn(alert);
		}
		else {
			fadeIn(notice);
		}
		if (result.data && result.data.result) {
			$this.loadResultData(result.data.result);
		}
		submit.removeAttr('disabled').removeClass('progress');
		solution.removeAttr('disabled');
		if (result.done) {
			App().task_list.markSelectedDone();
			App().task_list.moveForward();
		}
		else {
			solution.focus();
		}
	}

	function sendFailed(result) {
		console.log(result);
		alert.text('Операция не реализована')
		fadeIn(alert);
		submit.removeAttr('disabled').removeClass('progress');
		solution.removeAttr('disabled');
	}

	function solutionKeyDown(e) {
	    var keyCode = e.keyCode || e.which;
		if (e.ctrlKey && keyCode == 13)
			sendSolution();
		if (keyCode == 9) {
			e.preventDefault();
			var start = $(this).get(0).selectionStart;
			var end = $(this).get(0).selectionEnd;

			// set textarea value to: text before caret + tab + text after caret
			$(this).val($(this).val().substring(0, start)
			            + "\t"
			            + $(this).val().substring(end));

			// put caret at right position again
			$(this).get(0).selectionStart =
			$(this).get(0).selectionEnd = start + 1;
		}
	}


	function fadeOut(div, afterFadeOut) {
		div.animate({opacity: 0}, 200, function() { div.css('display', 'none'); if (afterFadeOut) afterFadeOut(); });
	}

	function fadeIn(div, afterFadeIn) {
		div.css('opacity', 0).css('display', 'inline-block').animate({opacity: 1}, 200, afterFadeIn);
	}

	this.loadResultData = function (resultData) {
		resultTable.css('display', 'none').html("");
		resultLegend.css('display', 'none');
		var table = $("<table></table>");
		var thead = $("<thead></thead>").appendTo(table);
		var theadRow = $("<tr></tr>").appendTo(thead);
		var count = resultData.columns.length;
		var columnCount = count;
		var orderColumn = -1;
		var i;
		for (i = 0; i < count; i++) {
			if (resultData.columns[i] == orderKey && !ordered)
				orderColumn = i;
			$("<th></th>").text(resultData.columns[i]).appendTo(theadRow);
		}
		count = resultData.extra_columns.length;
		for (i = 0; i < count; i++)
			$(theadRow.find("th")[resultData.extra_columns[i]]).addClass('extra');
		count = resultData.missing_columns.length;
		for (i = 0; i < count; i++)
			$("<th></th>").text(resultData.missing_columns[i]).addClass('missing').appendTo(theadRow);
		count = resultData.rows.length;
		var tbody = $("<tbody></tbody>").appendTo(table);
		var unorderedRows = new Array();
		for (i = 0; i < count; i++) {
			var row = $("<tr></tr>");
			var orderValue = -1;
			for (var k = 0; k < columnCount; k++)
			{
				var value = resultData.rows[i][k];
				if (k == orderColumn)
					orderValue = value;
				if (value === null)
					$("<td></td>").text('NULL').addClass('null-value').appendTo(row);
				else
					$("<td></td>").text(value).appendTo(row);
			}
			unorderedRows.push({row: row, order: orderValue});
		}
		count = resultData.extra_rows.length;
		for (i = 0; i < count; i++)
			unorderedRows[resultData.extra_rows[i]].row.addClass('extra');
		count = resultData.missing_rows.length;
		for (i = 0; i < count; i++) {
			var row = $("<tr></tr>").addClass('missing');
			var orderValue = -1;
			for (var k = 0; k < columnCount; k++) {
				var value = resultData.missing_rows[i][k]
				if (k == orderColumn)
					orderValue = value;
				if (value === null)
					$("<td></td>").text('NULL').addClass('null-value').appendTo(row);
				else
					$("<td></td>").text(value).appendTo(row);
			}
			unorderedRows.push({row: row, order: orderValue});
		}
		if (orderColumn != -1)
			unorderedRows.sort(function (a, b) 
				{
					if (a.order < b.order)
						return -1;
					if (a.order > b.order)
						return 1;
					return 0;
				});
		count = unorderedRows.length;
		for (var i = 0; i < count; i++)
			unorderedRows[i].row.appendTo(tbody);
		table.appendTo(resultTable);
		resultTable.css('overflow', 'hidden');
		fadeIn(resultTable, function() {
			updateResultTableSize();
			resultTable.css('overflow', 'auto');
		});
		resultLegendMissingColumn.css('display', (resultData.missing_columns.length > 0) ? '' : 'none');
		resultLegendExtraColumn.css('display', (resultData.extra_columns.length > 0) ? '' : 'none');
		resultLegendMissingRow.css('display', (resultData.missing_rows.length > 0) ? '' : 'none');
		resultLegendExtraRow.css('display', (resultData.extra_rows.length > 0) ? '' : 'none');
		var showLegend = (resultData.missing_columns.length > 0) ||
			(resultData.extra_columns.length > 0) ||
			(resultData.missing_rows.length > 0) ||
			(resultData.extra_rows.length > 0);
		if (showLegend)
			fadeIn(resultLegend);
	}

	this.init = function () {}
}

$(function () {
	MSSQLTask().init();
}) 