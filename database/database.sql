CREATE TABLE IF NOT EXISTS "usuarios" (
	"id" SERIAL,
	"username" VARCHAR(50) NOT NULL UNIQUE,
	"password_hash" VARCHAR(255) NOT NULL,
	"nombre_completo" VARCHAR(100) NOT NULL,
	"rol" VARCHAR(20) NOT NULL CHECK("[object Object]" IN administrador AND almacen AND dependiente AND contabilidad),
	"activo" BOOLEAN DEFAULT true,
	"created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "categorias" (
	"id" SERIAL,
	"nombre" VARCHAR(50) NOT NULL UNIQUE,
	"descripcion" TEXT,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "productos" (
	"id" SERIAL,
	"codigo_barras" VARCHAR(50) UNIQUE,
	"nombre" VARCHAR(100) NOT NULL,
	"descripcion" TEXT,
	"categoria_id" INTEGER,
	"precio_adquisicion" NUMERIC(10,2) NOT NULL,
	"pvp" NUMERIC(10,2) NOT NULL,
	"stock_actual" INTEGER NOT NULL DEFAULT 0,
	"stock_minimo" INTEGER NOT NULL DEFAULT 5,
	"imagen_url" VARCHAR(255),
	"created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "entradas_mercancia" (
	"id" SERIAL,
	"usuario_id" INTEGER NOT NULL,
	"proveedor" VARCHAR(100) NOT NULL,
	"numero_albaran" VARCHAR(50),
	"fecha" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"coste_total" NUMERIC(10,2) NOT NULL DEFAULT 0.00,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "lineas_entrada" (
	"id" SERIAL,
	"entrada_id" INTEGER NOT NULL,
	"producto_id" INTEGER NOT NULL,
	"cantidad" INTEGER NOT NULL CHECK("[object Object]" > 0),
	"coste_unitario" NUMERIC(10,2) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "mermas" (
	"id" SERIAL,
	"usuario_id" INTEGER NOT NULL,
	"producto_id" INTEGER NOT NULL,
	"cantidad" INTEGER NOT NULL CHECK("[object Object]" > 0),
	"tipo_motivo" VARCHAR(50) NOT NULL,
	"descripcion_justificacion" TEXT NOT NULL,
	"coste_perdida" NUMERIC(10,2) NOT NULL,
	"fecha" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "ventas" (
	"id" SERIAL,
	"usuario_id" INTEGER NOT NULL,
	"fecha" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"total_ingreso" NUMERIC(10,2) NOT NULL,
	"total_coste" NUMERIC(10,2) NOT NULL,
	"beneficio_neto" NUMERIC(10,2) NOT NULL,
	"metodo_pago" VARCHAR(30) DEFAULT 'efectivo',
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "lineas_venta" (
	"id" SERIAL,
	"venta_id" INTEGER NOT NULL,
	"producto_id" INTEGER NOT NULL,
	"cantidad" INTEGER NOT NULL CHECK("[object Object]" > 0),
	"precio_unitario_pvp" NUMERIC(10,2) NOT NULL,
	"coste_unitario" NUMERIC(10,2) NOT NULL,
	"subtotal" NUMERIC(10,2) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "devoluciones" (
	"id" SERIAL,
	"venta_id" INTEGER NOT NULL,
	"usuario_id" INTEGER NOT NULL,
	"fecha" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"total_reembolso" NUMERIC(10,2) NOT NULL,
	"motivo" TEXT,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "lineas_devolucion" (
	"id" SERIAL,
	"devolucion_id" INTEGER NOT NULL,
	"producto_id" INTEGER NOT NULL,
	"cantidad" INTEGER NOT NULL CHECK("[object Object]" > 0),
	"precio_unitario" NUMERIC(10,2) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "audit_logs" (
	"id" SERIAL,
	"usuario_id" INTEGER,
	"tipo_accion" VARCHAR(50) NOT NULL,
	"tabla_afectada" VARCHAR(50) NOT NULL,
	"registro_id" INTEGER,
	"detalles" TEXT,
	"fecha" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id")
);

ALTER TABLE "productos"
ADD FOREIGN KEY("categoria_id") REFERENCES "categorias"("id")
ON UPDATE NO ACTION ON DELETE SET NULL;
ALTER TABLE "entradas_mercancia"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuarios"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "lineas_entrada"
ADD FOREIGN KEY("entrada_id") REFERENCES "entradas_mercancia"("id")
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE "lineas_entrada"
ADD FOREIGN KEY("producto_id") REFERENCES "productos"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "mermas"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuarios"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "mermas"
ADD FOREIGN KEY("producto_id") REFERENCES "productos"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "ventas"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuarios"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "lineas_venta"
ADD FOREIGN KEY("venta_id") REFERENCES "ventas"("id")
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE "lineas_venta"
ADD FOREIGN KEY("producto_id") REFERENCES "productos"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "devoluciones"
ADD FOREIGN KEY("venta_id") REFERENCES "ventas"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "devoluciones"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuarios"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "lineas_devolucion"
ADD FOREIGN KEY("devolucion_id") REFERENCES "devoluciones"("id")
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE "lineas_devolucion"
ADD FOREIGN KEY("producto_id") REFERENCES "productos"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "audit_logs"
ADD FOREIGN KEY("usuario_id") REFERENCES "usuarios"("id")
ON UPDATE NO ACTION ON DELETE SET NULL;
