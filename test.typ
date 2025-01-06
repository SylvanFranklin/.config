#import "@preview/cetz:0.3.1" as cetz
#set page(width: auto, height: auto)
// A fixed offset vector in RR^5

#let offset = (
  0.012445987628374,
  0.049637456817326,
  0.291638765345987,
  0.084127469734981,
  0.000249356192837,
)

// A fixed vector of colors
#let colors = (blue, green, green, blue)

// The coordinate in ZZ^5 after cutting the hyper-lattice
#let level(coord, dir) = calc.floor((
  coord.at(0) * calc.cos(dir * 72deg) + coord.at(1) * calc.sin(dir * 72deg) - offset.at(calc.rem-euclid(dir, 5))
))

// Calculate the full coordinate in ZZ^5, given a generic point
#let levels(coord) = range(5).map(level.with(coord))

// Project the lattice point in ZZ^5 down to the plane
#let project(levels) = (
  range(5).map(i => (levels.at(i) + offset.at(calc.rem-euclid(i, 5))) * calc.cos(i * 72deg)).sum() * 2 / 5,
  range(5).map(i => (levels.at(i) + offset.at(calc.rem-euclid(i, 5))) * calc.sin(i * 72deg)).sum() * 2 / 5,
)

// Calculate the intersection coordinate
#let coord-intersection(dir1, dir2, lvl1, lvl2) = {
  import calc: *
  // The lines are given by the equation
  //  cos(dir * 72deg) x + sin(dir * 72deg) y = offset[dir] + lvl
  let Delta = sin((dir1 - dir2) * 72deg)
  let x = sin(dir1 * 72deg) * (lvl2 + offset.at(dir2)) - sin(dir2 * 72deg) * (lvl1 + offset.at(dir1))
  let y = cos(dir2 * 72deg) * (lvl1 + offset.at(dir1)) - cos(dir1 * 72deg) * (lvl2 + offset.at(dir2))
  return (x / Delta, y / Delta)
}

#let radius = 4
#cetz.canvas({
  import cetz.draw: *
  circle((0, 0), radius: radius)

  for dir1 in range(5) {
    for dir2 in range(dir1) {
      for lvl1 in range(-radius, radius) {
        for lvl2 in range(-radius, radius) {
          let (x, y) = coord-intersection(dir1, dir2, lvl1, lvl2)
          if x * x + y * y >= radius * radius {
            continue
          }
          let eps = 0.05 / calc.abs(calc.sin((dir1 - dir2) * 72deg))
          line(
            close: true,
            stroke: none,
            fill: colors.at(calc.abs(dir1 - dir2) - 1),
            // Four points infinitesimally close to the intersection
            ..((-eps, -eps), (-1 + eps, -eps), (-1 + eps, -1 + eps), (-eps, -1 + eps)).map(((sgn1, sgn2)) => {
              let lvls = range(5).map(i => if i == dir1 {
                lvl1 + sgn1
              } else if i == dir2 {
                lvl2 + sgn2
              } else {
                level((x, y), i)
              })
              project(lvls)
            }),
          )
        }
      }
    }
  }
})

