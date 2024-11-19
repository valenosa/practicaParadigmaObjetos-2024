class Plato {
  method aptoCeliaco()
  method valoracion()
  method esEspecial()
  // method precio() = if (self.aptoCeliaco()) {self.valoracion()*300 + 1200} else {self.valoracion()*300}
  method precio() {
    var p = self.valoracion()*300

    if (self.aptoCeliaco()) {
      p += 1200
    }
    return p
  }
}