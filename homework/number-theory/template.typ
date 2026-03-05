
#show regex("\{.+\}"): "not"


test



// #let parse-actions(body) = {
//
//   let extract(it) = {
//     ""
//     if it == [ ] {
//       " "
//     } else if type(it) == type(3) {
//       str(it)
//     } else if it.func() == text {
//       it.text
//     } else if it.func() == [].func() {
//       it.children.map(extract).join()
//     }
//   }
//
//   extract(body).clusters().join()
// }
//
// #show: parse-actions
//
//
//
//
//
// Goal
//
// Given
