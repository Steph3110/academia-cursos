from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


OUTPUT_DIR = Path(__file__).resolve().parent
WIDTH = 2600
HEIGHT = 1600
BACKGROUND = "#F4F6F5"
INK = "#183333"
MUTED = "#526967"
LINE = "#77928C"
WHITE = "#FFFFFF"
TEAL = "#167C74"
TEAL_LIGHT = "#E2F1EE"
GOLD = "#D79A36"
GOLD_LIGHT = "#FBF0D8"
BLUE = "#426C9A"
BLUE_LIGHT = "#E7EFF7"
CORAL = "#C9634D"
CORAL_LIGHT = "#F9E9E4"


def font(size, bold=False):
    font_name = "arialbd.ttf" if bold else "arial.ttf"
    font_path = Path("C:/Windows/Fonts") / font_name
    return ImageFont.truetype(str(font_path), size)


def make_canvas(title):
    image = Image.new("RGB", (WIDTH, HEIGHT), BACKGROUND)
    draw = ImageDraw.Draw(image)
    draw.text((100, 55), title, font=font(54, True), fill=INK)
    return image, draw


def save_png(image, filename):
    destination = OUTPUT_DIR / filename
    temporary = destination.with_name(f"{destination.stem}.tmp.png")
    image.save(temporary, dpi=(180, 180))
    temporary.replace(destination)


def centered_label(draw, xy, text, color=INK):
    bounds = draw.textbbox((0, 0), text, font=font(22, True))
    width = bounds[2] - bounds[0]
    height = bounds[3] - bounds[1]
    x, y = xy
    draw.rounded_rectangle((x, y, x + width + 24, y + height + 18), radius=10, fill=WHITE, outline="#C8D6D1", width=2)
    draw.text((x + 12, y + 7), text, font=font(22, True), fill=color)


def draw_card(draw, box, title, rows, accent, tint, row_font=25):
    x1, y1, x2, y2 = box
    draw.rounded_rectangle(box, radius=18, fill=WHITE, outline="#C8D6D1", width=3)
    draw.rounded_rectangle((x1, y1, x2, y1 + 66), radius=16, fill=accent)
    draw.rectangle((x1, y1 + 42, x2, y1 + 66), fill=accent)
    draw.text((x1 + 24, y1 + 12), title, font=font(31, True), fill=WHITE)
    y = y1 + 86
    for row in rows:
        if row[0]:
            draw.rounded_rectangle((x1 + 18, y + 2, x1 + 78, y + 34), radius=7, fill=tint)
            draw.text((x1 + 26, y + 5), row[0], font=font(17, True), fill=accent)
            text_x = x1 + 92
        else:
            text_x = x1 + 24
        draw.text((text_x, y), row[1], font=font(row_font), fill=INK)
        y += 46


def draw_link(draw, points, relationship, relationship_xy, cardinality, cardinality_xy):
    draw.line(points, fill=LINE, width=5, joint="curve")
    centered_label(draw, relationship_xy, relationship)
    centered_label(draw, cardinality_xy, cardinality)


def draw_er():
    image, draw = make_canvas("Modelo entidad-relación")

    draw_link(draw, [(690, 590), (790, 590), (790, 1030), (920, 1030)], "realiza", (735, 850), "1 : N", (735, 790))
    draw_link(draw, [(1230, 680), (1230, 870)], "recibe", (1250, 690), "1 : N", (1250, 770))
    draw_link(draw, [(1700, 315), (1610, 315), (1610, 420), (1540, 420)], "imparte", (1575, 375), "1 : N", (1585, 335))
    draw_link(draw, [(1700, 900), (1615, 900), (1615, 560), (1540, 560)], "clasifica", (1575, 650), "1 : N", (1580, 745))

    draw_card(draw, (100, 410, 690, 790), "ESTUDIANTE", [
        ("", "id_estudiante"), ("", "nombre"), ("", "correo"), ("", "ciudad"),
    ], BLUE, BLUE_LIGHT)
    draw_card(draw, (920, 250, 1540, 680), "CURSO", [
        ("", "id_curso"), ("", "id_profesor"), ("", "id_categoria"),
        ("", "nombre"), ("", "precio_base"),
    ], TEAL, TEAL_LIGHT)
    draw_card(draw, (920, 870, 1540, 1300), "INSCRIPCION", [
        ("", "id_inscripcion"), ("", "id_estudiante"), ("", "id_curso"),
        ("", "fecha"), ("", "importe_final"), ("", "estado"),
    ], CORAL, CORAL_LIGHT)
    draw_card(draw, (1700, 220, 2300, 490), "PROFESOR", [
        ("", "id_profesor"), ("", "nombre"), ("", "especialidad"),
    ], GOLD, GOLD_LIGHT)
    draw_card(draw, (1700, 760, 2300, 1030), "CATEGORIA", [
        ("", "id_categoria"), ("", "nombre"),
    ], GOLD, GOLD_LIGHT)

    save_png(image, "modelo_entidad_relacion.png")


def draw_schema():
    image, draw = make_canvas("Esquema relacional")

    draw.line([(760, 710), (850, 710), (850, 625), (970, 625)], fill=LINE, width=5, joint="curve")
    draw.line([(1970, 720), (1850, 720), (1850, 900), (1730, 900)], fill=LINE, width=5, joint="curve")
    draw.line([(2260, 400), (2260, 540)], fill=LINE, width=5)
    draw.line([(2260, 1100), (2260, 960)], fill=LINE, width=5)

    draw_card(draw, (110, 560, 760, 880), "ESTUDIANTE", [
        ("PK", "id_estudiante INT"), ("", "nombre VARCHAR(100)"),
        ("", "correo VARCHAR(150)"), ("", "ciudad VARCHAR(80)"),
    ], BLUE, BLUE_LIGHT, 22)
    draw_card(draw, (970, 500, 1730, 1000), "INSCRIPCION", [
        ("PK", "id_inscripcion INT"), ("FK", "id_estudiante INT"), ("FK", "id_curso INT"),
        ("", "fecha DATE"), ("", "importe_final DECIMAL(12,2)"),
        ("", "estado ENUM('pendiente','pagada','cancelada')"),
    ], CORAL, CORAL_LIGHT, 22)
    draw_card(draw, (1970, 540, 2540, 900), "CURSO", [
        ("PK", "id_curso INT"), ("FK", "id_profesor INT"), ("FK", "id_categoria INT"),
        ("", "nombre VARCHAR(120)"), ("", "precio_base DECIMAL(12,2)"),
    ], TEAL, TEAL_LIGHT, 21)
    draw_card(draw, (1970, 140, 2540, 400), "PROFESOR", [
        ("PK", "id_profesor INT"), ("", "nombre VARCHAR(100)"),
        ("", "especialidad VARCHAR(100)"),
    ], GOLD, GOLD_LIGHT, 21)
    draw_card(draw, (1970, 1100, 2540, 1360), "CATEGORIA", [
        ("PK", "id_categoria INT"), ("", "nombre VARCHAR(80)"),
    ], GOLD, GOLD_LIGHT, 21)

    save_png(image, "esquema_relacional.png")


if __name__ == "__main__":
    draw_er()
    draw_schema()