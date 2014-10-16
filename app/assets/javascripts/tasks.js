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
		$this = this;

	submit.click(sendSolution);
	solution.keydown(solutionKeyDown);
	$(window).resize(updateResultTableSize);

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
			.fail(sendFailed)
			.always(afterSend);
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
		if (result.data.result) {
			$this.loadResultData(result.data.result);
		}
	}

	function sendFailed(result) {
		console.log(result);
		alert.text('Операция не реализована')
		fadeIn(alert);
	}

	function afterSend() {
		submit.removeAttr('disabled').removeClass('progress');
		solution.removeAttr('disabled');
	}

	function solutionKeyDown(e) {
		if (e.ctrlKey && e.keyCode == 13)
			sendSolution();
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
		var i;
		for (i = 0; i < count; i++)
			$("<th></th>").text(resultData.columns[i]).appendTo(theadRow);
		count = resultData.extra_columns.length;
		for (i = 0; i < count; i++)
			$(theadRow.find("th")[resultData.extra_columns[i]]).addClass('extra');
		count = resultData.missing_columns.length;
		for (i = 0; i < count; i++)
			$("<th></th>").text(resultData.missing_columns[i]).addClass('missing').appendTo(theadRow);
		count = resultData.rows.length;
		var tbody = $("<tbody></tbody>").appendTo(table);
		for (i = 0; i < count; i++) {
			var row = $("<tr></tr>").appendTo(tbody);
			for (var k = 0; k < columnCount; k++)
				$("<td></td>").text(resultData.rows[i][k]).appendTo(row);
		}
		count = resultData.extra_rows.length;
		for (i = 0; i < count; i++)
			$(tbody.find("tr")[resultData.extra_rows[i]]).addClass('extra');
		count = resultData.missing_rows.length;
		for (i = 0; i < count; i++) {
			var row = $("<tr></tr>").addClass('missing').appendTo(tbody);
			for (var k = 0; k < columnCount; k++)
				$("<td></td>").text(resultData.missing_rows[i][k]).appendTo(row);
		}
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