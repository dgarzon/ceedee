module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def to_minutes(seconds)
    m = (seconds/60).floor
    s = (seconds - (m * 60)).round

    if m < 10
      m = "0#{m}"
    end

    if s < 10
      s = "0#{s}"
    end

    return "#{m}:#{s}"
  end
end
