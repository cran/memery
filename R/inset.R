#' Meme plot inset templates
#'
#' Templates for the position and background of a ggplot inset.
#'
#' @details
#' `inset_position()` and `inset_background()` assist with some basic options for
#' position and background of the optional ggplot inset graphic. `inset_templates()`
#' can be used to view the available templates. See examples. If a template is
#' not available to suit your needs, provide your own argument list to `meme()`
#' in the form of, e.g., `inset_pos = list(w = 0.95, h = 0.6, x = 0.5, y = 0.325)`.
#'
#' @section Size and position:
#' The coordinate system for the meme plot ranges from zero to one in x and y.
#' The width, height and (x,y) center defined by `inset_position()` arguments
#' therefore take values between zero and one.
#'
#' The default position is for an inset plot that takes up 95\% of the width and
#' 60\% of the height of the meme plot, with 2.5\% margins on the sides and bottom.
#' Other templates include four corner thumbnails. To use these, set `type` equal
#' to `"tl"`, `"tr"`, `"br"` or `"bl"`, for top right, top left, bottom right and
#' bottom left, respectively. There is also a `"center"` type.
#'
#' When specifying the corner or center inset types, the inset is a square
#' thumbnail with width and height of 0.2 units (20\%) and 0.025 (2.5\%) margins
#' from the edges of the plot. However, these templates are not absolute. You
#' can further adjust the size and distance from the edges using `size` and
#' `margin`. These arguments can be scalar, in which case the inset remains
#' square and the margins are equal. If a length-2 vector, `size` can provide
#' unique width and height for a rectangular inset. Similarly, `margin` can
#' provide different margins for the distance to a side vs. the top or bottom
#' edge of the meme plot.
#'
#' For `type = "center"`, `size` is used but `margin` is ignored, giving you
#' control over the thumbnail size. Appending the letter `q` to a corner
#' thumbnail template ID, e.g. `type = "blq"`, yields a quadrant plot. In
#' contrast to `type = "center"`, these types allow for user control over
#' margins for plots of fixed coverage area. Specifying the right combination of
#' `size` and `margin` with a corner thumbnail template can be used to create a
#' quadrant plot, but using a quadrant template simplifies this.
#'
#' `size` and `margin` are provided for convenience, adding more control over
#' the position templates. If you require more specific size and position
#' control, simply pass your own 4-argument list as described above. This is the
#' structure generated by `inset_position()` for any `type` and expected by `meme()`.
#'
#' @section Background:
#' For `inset_background()`, the few templates all revolve around the
#' `type = "default"` template. `type = "sq"` simply removes the rounded corners.
#' `"op"` provides a fully opaque white background instead of the default 50\%
#' transparency. `"opsq"` does both. `"blank"` hides the background panel. There
#' is no substantial need to provide many templates because, as with
#' `inset_position()`, `inset_background()` generates a simple list of a few
#' arguments that can be easily provided to `meme()` explicitly without the use of
#' `inset_background()`.
#'
#' @param type character, name of template.
#' @param size numeric, width (length-1) or width and height (length-2) of inset.
#' See details.
#' @param margin numeric, x-axis margin (length-1) or x- and y-axis margins
#' (length-2) around corner insets. See details.
#' @name inset
#'
#' @return a list of arguments passed to either `inset_pos` or `inset_bg` in `meme()`.
#'
#' @examples
#' inset_templates("position")
#' inset_templates("background")
#' inset_position()
#' inset_position("br")
#' inset_position("brq", margin = 0.05)
#' inset_position("br", size = 0.4, margin = 0)
#' inset_background()
#' inset_background("opsq")
#' inset_background("blank")
NULL

#' @export
#' @rdname inset
inset_position <- function(type = "default", size = 0.2, margin = 0.025){
  if(!type %in% inset_templates("position")) stop("Invalid inset position template.")
  size <- rep(size, length.out = 2)
  margin <- rep(margin, length.out = 2)
  lwr <- size / 2 + margin
  upr <- 1 - lwr
  qsize <- c(0.5, 0.5) - 2 * margin
  qlwr <- qsize / 2 + margin
  qupr <- 1 - qlwr
  switch(type,
         default = list(w = 0.95, h = 0.6, x = 0.5, y = 0.325),
         tl = list(w = size[1], h = size[2], x = lwr[1], y = upr[2]),
         tr = list(w = size[1], h = size[2], x = upr[1], y = upr[2]),
         br = list(w = size[1], h = size[2], x = upr[1], y = lwr[2]),
         bl = list(w = size[1], h = size[2], x = lwr[1], y = lwr[2]),
         tlq = list(w = qsize[1], h = qsize[2], x = qlwr[1], y = qupr[2]),
         trq = list(w = qsize[1], h = qsize[2], x = qupr[1], y = qupr[2]),
         brq = list(w = qsize[1], h = qsize[2], x = qupr[1], y = qlwr[2]),
         blq = list(w = qsize[1], h = qsize[2], x = qlwr[1], y = qlwr[2]),
         center = list(w = size[1], h = size[2], x = 0.5, y = 0.5)
  )
}

#' @export
#' @rdname inset
inset_background <- function(type = "default"){
  if(!type %in% inset_templates("background")) stop("Invalid inset background template.")
  switch(type,
         default = list(fill = "#FFFFFF50", col = NA, r = grid::unit(0.025, "snpc")),
         op = list(fill = "#FFFFFF", col = NA, r = grid::unit(0.025, "snpc")),
         sq = list(fill = "#FFFFFF50", col = NA, r = grid::unit(0, "snpc")),
         opsq = list(fill = "#FFFFFF", col = NA, r = grid::unit(0, "snpc")),
         blank = list(fill = NA, col = NA, r = grid::unit(0, "snpc"))
  )
}

#' @export
#' @rdname inset
inset_templates <- function(type){
  switch(type,
         position = c("default", "tl", "tr", "br", "bl", "tlq", "trq", "brq", "blq", "center"),
         background = c("default", "op", "sq", "opsq", "blank")
  )
}

#' Default meme theme
#'
#' The default ggplot2 theme for meme plots.
#'
#' @param base_size numeric, the base size.
#' @param base_family character, the base font family.
#' @param base_col character, the base color for all title text and axis lines
#' and ticks.
#'
#' @return a ggplot2 theme.
#' @export
memetheme <- function(base_size = 14, base_family = "", base_col = "white"){
  ggplot2::theme_gray(base_size = base_size, base_family = base_family) +
  ggplot2::theme(
    panel.grid.major = ggplot2::element_line(linewidth = 0.5, colour = "gray"),
    title = ggplot2::element_text(colour = base_col),
    axis.text = ggplot2::element_text(colour = base_col),
    axis.ticks = ggplot2::element_line(colour = base_col),
    axis.line = ggplot2::element_line(linewidth = 1, colour = base_col),
    axis.ticks.length = ggplot2::unit(0.35, "cm"), legend.position = "bottom",
    legend.justification = "right", legend.title = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = base_size), text = ggplot2::element_text(size = 18),
    plot.title = ggplot2::element_text(size = 20, hjust = 0),
    panel.spacing.x = ggplot2::unit(0.25, "cm"),
    plot.margin = ggplot2::unit(c(0.25, 0.5, 0.25, 0.25), "cm"),
    strip.background = ggplot2::element_rect(fill = "#33333350", colour = base_col),
    strip.text = ggplot2::element_text(size = base_size, colour = base_col),
    panel.background = ggplot2::element_rect(fill = NA),
    plot.background = ggplot2::element_rect(fill = NA, colour = NA), complete = TRUE)
}
