part of charts;

/// Creates the segments for column series.
class ColumnSegment extends ChartSegment {
  num x1, y1, x2, y2;
  BorderRadius _borderRadius;
  RRect _trackRect;
  _CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for column series.
    if (series.gradient == null) {
      if (color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : (hasPointColor ? _currentPoint.pointColorMapper : color)
          ..style = PaintingStyle.fill;
        _defaultFillColor = fillPaint;
      }
    } else {
      fillPaint = _getLinearGradientPaint(series.gradient, _currentPoint.region,
          series._chart._requireInvertedAxis);
    }
    fillPaint.color = fillPaint.color.withOpacity(series.opacity);
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    if (strokeColor != null) {
      strokePaint = Paint()
        ..color = _currentPoint.isEmpty == true
            ? series.emptyPointSettings.borderColor
            : strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _currentPoint.isEmpty == true
            ? series.emptyPointSettings.borderWidth
            : strokeWidth;
      _defaultStrokeColor = strokePaint;
    }
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    strokePaint.color = strokePaint.color == Colors.transparent
        ? strokePaint.color
        : strokePaint.color.withOpacity(series.opacity);
    return strokePaint;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;
    if (color != null) {
      _trackerFillPaint = Paint()
        ..color = columnSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;
    _trackerStrokePaint = Paint()
      ..color = columnSeries.trackBorderColor
      ..strokeWidth = columnSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    columnSeries.trackBorderWidth == 0
        ? _trackerStrokePaint.color = Colors.transparent
        : _trackerStrokePaint.color;
    return _trackerStrokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;
    _borderRadius = columnSeries.borderRadius;
    if (_currentPoint.region != null) {
      segmentRect = RRect.fromRectAndCorners(
        _currentPoint.region,
        bottomLeft: _borderRadius.bottomLeft,
        bottomRight: _borderRadius.bottomRight,
        topLeft: _borderRadius.topLeft,
        topRight: _borderRadius.topRight,
      );

      //Tracker rect
      if (columnSeries.isTrackVisible) {
        _trackRect = RRect.fromRectAndCorners(
          _currentPoint.trackerRectRegion,
          bottomLeft: _borderRadius.bottomLeft,
          bottomRight: _borderRadius.bottomRight,
          topLeft: _borderRadius.topLeft,
          topRight: _borderRadius.topRight,
        );
      }
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final ColumnSeries<dynamic, dynamic> columnSeries = series;

    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);

    if (_trackerFillPaint != null && columnSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint);
    }

    if (_trackerStrokePaint != null && columnSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerStrokePaint);
    }

    if (fillPaint != null) {
      series.animationDuration > 0
          ? _animateColumnSeries(canvas, series, fillPaint, segmentRect,
              _currentPoint.yValue, animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint);
    }
    if (strokePaint != null) {
      series.animationDuration > 0
          ? _animateColumnSeries(canvas, series, strokePaint, segmentRect,
              _currentPoint.yValue, animationFactor)
          : canvas.drawRRect(segmentRect, strokePaint);
    }
  }

  /// Method to set data.
  void _setData(List<num> values) {
    x1 = values[0];
    y1 = values[1];
  }
}
