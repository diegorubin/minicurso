module SnippetsHelper
  def render_code(code)
    raw h(code).gsub("\n","<br/>").gsub(" ", "&nbsp;")
  end
end
