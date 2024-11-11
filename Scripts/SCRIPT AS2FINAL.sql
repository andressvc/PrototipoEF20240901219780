-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-11-2024 a las 06:51:47
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `colchoneria`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiarContraModulo` (IN `p_usuario` INT, IN `p_nueva_contrasenia` VARCHAR(100))   BEGIN
    -- Actualizar la contraseña del usuario
    UPDATE tbl_usuarios
    SET password_usuario = p_nueva_contrasenia
    WHERE pk_id_usuario = p_usuario;

    -- Confirmar que el cambio se realizó
    IF ROW_COUNT() > 0 THEN
        SELECT 'Contraseña actualizada con éxito' AS resultado;
    ELSE
        SELECT 'Usuario no encontrado' AS resultado;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiarContrasenia` (IN `usuario` VARCHAR(255), IN `nuevaContrasenia` VARCHAR(255), IN `respuestaSeguridad` VARCHAR(255))   BEGIN
    DECLARE respuestaGuardada VARCHAR(255);
    DECLARE usuarioExiste INT;

    -- Verificar si el usuario existe
    SELECT COUNT(*) INTO usuarioExiste 
    FROM tbl_usuarios 
    WHERE username_usuario = usuario;

    IF usuarioExiste = 0 THEN
        -- Si el usuario no existe, devolver mensaje de error
        SELECT 'Usuario no encontrado' AS resultado;
    ELSE
        -- Obtener la respuesta de seguridad desde la base de datos
        SELECT respuesta INTO respuestaGuardada 
        FROM tbl_usuarios 
        WHERE username_usuario = usuario;

        -- Verificar si la respuesta ingresada coincide con la guardada
        IF LOWER(respuestaGuardada) = LOWER(respuestaSeguridad) THEN
            -- Actualizar la contraseña
            UPDATE tbl_usuarios
            SET password_usuario = nuevaContrasenia
            WHERE username_usuario = usuario;
            
            -- Devolver el resultado exitoso
            SELECT 'Contraseña actualizada con éxito' AS resultado;
        ELSE
            -- Devolver resultado si la respuesta de seguridad es incorrecta
            SELECT 'Respuesta de seguridad incorrecta' AS resultado;
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambioContrasenia` (IN `p_usuario` VARCHAR(20))   BEGIN
    DECLARE usuario_existe INT;

    SELECT COUNT(*) INTO usuario_existe
    FROM tbl_usuarios
    WHERE username_usuario = p_usuario;

    -- Si el usuario existe, actualiza el tiempo de última conexión
    IF usuario_existe > 0 THEN        
        SELECT 'Usuario encontrado' AS resu;
    ELSE
        SELECT 'Usuario no encontrado' AS resu;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procedimientoLogin` (IN `p_usuario` VARCHAR(20), IN `p_clave` VARCHAR(100))   BEGIN
    DECLARE usuario_existe INT;

    SELECT COUNT(*) INTO usuario_existe
    FROM tbl_usuarios
    WHERE username_usuario = p_usuario AND password_usuario = p_clave;

    -- Si el usuario existe, actualiza el tiempo de última conexión
    IF usuario_existe > 0 THEN
        UPDATE tbl_usuarios
        SET ultima_conexion_usuario = NOW()
        WHERE username_usuario = p_usuario AND password_usuario = p_clave;
        
        SELECT 'Inicio de sesión exitoso' AS resultado;
    ELSE
        SELECT 'Inicio de sesión fallido' AS resultado;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ayuda`
--

CREATE TABLE `ayuda` (
  `Id_ayuda` int(11) NOT NULL,
  `Ruta` varchar(255) DEFAULT NULL,
  `indice` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ayuda`
--

INSERT INTO `ayuda` (`Id_ayuda`, `Ruta`, `indice`, `estado`) VALUES
(1, 'AyudaNavegador.chm', 'AyudaNav.html', 1),
(2, 'AyudaReportes.chm', 'AyudaRep.html', 1),
(8, 'AyudaMonitoreoAlmacen.chm', 'AyudaMonAlmacen.html', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_activofijo`
--

CREATE TABLE `tbl_activofijo` (
  `Pk_Id_ActivoFijo` int(11) NOT NULL,
  `Codigo_Activo` varchar(50) NOT NULL,
  `Pk_Id_TipoActivoFijo` int(11) DEFAULT NULL,
  `Descripcion` varchar(255) NOT NULL,
  `Pk_Id_Identidad` int(11) DEFAULT NULL,
  `Modelo` varchar(100) DEFAULT NULL,
  `Fecha_Adquisicion` date DEFAULT NULL,
  `Costo_Adquisicion` decimal(10,2) DEFAULT NULL,
  `Vida_Util` decimal(5,2) DEFAULT NULL,
  `Valor_Residual` decimal(10,2) DEFAULT NULL,
  `Estado` tinyint(4) DEFAULT NULL,
  `Pk_Id_Cuenta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_aplicaciones`
--

CREATE TABLE `tbl_aplicaciones` (
  `Pk_id_aplicacion` int(11) NOT NULL,
  `nombre_aplicacion` varchar(50) NOT NULL,
  `descripcion_aplicacion` varchar(150) NOT NULL,
  `estado_aplicacion` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_aplicaciones`
--

INSERT INTO `tbl_aplicaciones` (`Pk_id_aplicacion`, `nombre_aplicacion`, `descripcion_aplicacion`, `estado_aplicacion`) VALUES
(1000, 'MDI SEGURIDAD', 'PARA SEGURIDAD', 1),
(1001, 'Mant. Usuario', 'PARA SEGURIDAD', 1),
(1002, 'Mant. Aplicación', 'PARA SEGURIDAD', 1),
(1003, 'Mant. Modulo', 'PARA SEGURIDAD', 1),
(1004, 'Mant. Perfil', 'PARA SEGURIDAD', 1),
(1101, 'Asign. Modulo Aplicacion', 'PARA SEGURIDAD', 1),
(1102, 'Asign. Aplicacion Perfil', 'PARA SEGURIDAD', 1),
(1103, 'Asign. Perfil Usuario', 'PARA SEGURIDAD', 1),
(1201, 'Pcs. Cambio Contraseña', 'PARA SEGURIDAD', 1),
(1301, 'Pcs. BITACORA', 'PARA SEGURIDAD', 1),
(2000, 'MDI LOGISTICA', 'PARA LOGISTICA', 1),
(3000, 'MDI COMPRAS Y VENTAS', 'PARA COMPRAS Y VENTAS', 1),
(5000, 'MDI PRODUCCIÓN', 'PARA PRODUCCIÓN', 1),
(6000, 'MDI NOMINAS', 'PARA NOMINAS', 1),
(6001, 'Mant. Trabajadores', 'PARA NOMINAS', 1),
(6002, 'Mant. Puestos de Trabajo', 'PARA NOMINAS', 1),
(6003, 'Mant. Departamentos', 'PARA NOMINAS', 1),
(6004, 'Mant. Contratos', 'PARA NOMINAS', 1),
(6005, 'Mant. Percepciones', 'PARA NOMINAS', 1),
(6006, 'Mant. Horas Extras', 'PARA NOMINAS', 1),
(6007, 'Mant. Faltas', 'PARA NOMINAS', 1),
(6008, 'Mant. Anticipos', 'PARA NOMINAS', 1),
(6101, 'Asgn. Puesto - Depto.', 'PARA NOMINAS', 1),
(6102, 'Asgn. Puesto - Trabajador', 'PARA NOMINAS', 1),
(6103, 'Asgn. Contrato Trabajador', 'PARA NOMINAS', 1),
(6104, 'Asgn. Prestaciones Contrato', 'PARA NOMINAS', 1),
(6105, 'Asgn. Prestaciones Individual', 'PARA NOMINAS', 1),
(6106, 'Prcs. Nomina', 'PARA NOMINAS', 1),
(6107, 'Cálculo liquidaciones', 'PARA NÓMINAS', 1),
(6201, 'Rpt. Planillas', 'PARA NOMINAS', 1),
(6202, 'Rpt. Contratos', 'PARA NOMINAS', 1),
(6203, 'Rpt. Trabajadores', 'PARA NOMINAS', 1),
(6301, 'ACCESO SEGURIDAD', 'PARA NOMINAS', 1),
(7000, 'MDI BANCOS', 'PARA BANCOS', 1),
(8000, 'MDI CONTRABILIDAD', 'PARA CONTRABILIDAD', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_asignaciones_perfils_usuario`
--

CREATE TABLE `tbl_asignaciones_perfils_usuario` (
  `PK_id_Perfil_Usuario` int(11) NOT NULL,
  `Fk_id_usuario` int(11) NOT NULL,
  `Fk_id_perfil` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_asignaciones_perfils_usuario`
--

INSERT INTO `tbl_asignaciones_perfils_usuario` (`PK_id_Perfil_Usuario`, `Fk_id_usuario`, `Fk_id_perfil`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_asignacion_modulo_aplicacion`
--

CREATE TABLE `tbl_asignacion_modulo_aplicacion` (
  `Fk_id_modulos` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_asignacion_modulo_aplicacion`
--

INSERT INTO `tbl_asignacion_modulo_aplicacion` (`Fk_id_modulos`, `Fk_id_aplicacion`) VALUES
(1000, 1000),
(1000, 1001),
(1000, 1002),
(1000, 1003),
(1000, 1004),
(1000, 1102),
(1000, 1103),
(1000, 1201),
(1000, 1301),
(2000, 2000),
(3000, 3000),
(5000, 5000),
(6000, 6000),
(6000, 6001),
(6000, 6002),
(6000, 6003),
(6000, 6004),
(6000, 6005),
(6000, 6006),
(6000, 6007),
(6000, 6101),
(6000, 6102),
(6000, 6103),
(6000, 6104),
(6000, 6105),
(6000, 6106),
(6000, 6201),
(6000, 6202),
(6000, 6203),
(6000, 6301),
(7000, 7000),
(8000, 8000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_asignacion_vacaciones`
--

CREATE TABLE `tbl_asignacion_vacaciones` (
  `pk_registro_vaciones` int(11) NOT NULL,
  `asignacion_vacaciones_descripcion` varchar(25) DEFAULT NULL,
  `asignacion_vacaciones_fecha_inicio` date DEFAULT NULL,
  `asignacion_vacaciones_fecha_fin` date DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_auditorias`
--

CREATE TABLE `tbl_auditorias` (
  `Pk_ID_AUDITORIA` int(11) NOT NULL,
  `Fk_ID_BODEGA` int(11) NOT NULL,
  `Fk_ID_PRODUCTO` int(11) NOT NULL,
  `FECHA_AUDITORIA` date DEFAULT NULL,
  `DISCREPANCIA_DETECTADA` tinyint(1) DEFAULT 0,
  `CANTIDAD_REGISTRADA` int(11) NOT NULL,
  `CANTIDAD_FISICA` int(11) NOT NULL,
  `OBSERVACIONES` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_auditorias`
--

INSERT INTO `tbl_auditorias` (`Pk_ID_AUDITORIA`, `Fk_ID_BODEGA`, `Fk_ID_PRODUCTO`, `FECHA_AUDITORIA`, `DISCREPANCIA_DETECTADA`, `CANTIDAD_REGISTRADA`, `CANTIDAD_FISICA`, `OBSERVACIONES`) VALUES
(1, 1, 1, '2024-11-08', 0, 20, 20, 'Auditoría de rutina, todo en orden.'),
(2, 2, 3, '2024-11-08', 1, 8, 10, 'Discrepancia detectada en el Sofá 3 Plazas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_banco`
--

CREATE TABLE `tbl_banco` (
  `pk_banco_id` int(11) NOT NULL,
  `banco_nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_bitacora`
--

CREATE TABLE `tbl_bitacora` (
  `Pk_id_bitacora` int(11) NOT NULL,
  `Fk_id_usuario` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `fecha_bitacora` date NOT NULL,
  `hora_bitacora` time NOT NULL,
  `host_bitacora` varchar(45) NOT NULL,
  `ip_bitacora` varchar(100) NOT NULL,
  `accion_bitacora` varchar(200) NOT NULL,
  `tabla` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_bitacora`
--

INSERT INTO `tbl_bitacora` (`Pk_id_bitacora`, `Fk_id_usuario`, `Fk_id_aplicacion`, `fecha_bitacora`, `hora_bitacora`, `host_bitacora`, `ip_bitacora`, `accion_bitacora`, `tabla`) VALUES
(200, 1, 1000, '2024-11-08', '00:03:02', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(201, 1, 1000, '2024-11-08', '00:04:33', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(202, 1, 1000, '2024-11-08', '00:07:41', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(203, 1, 1000, '2024-11-08', '00:11:08', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(204, 1, 1000, '2024-11-08', '00:13:27', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(205, 1, 1000, '2024-11-08', '15:07:38', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(206, 1, 1000, '2024-11-08', '15:10:49', 'Andres', '192.168.1.3', 'Se logeo al sistema', 'Login'),
(207, 1, 1000, '2024-11-08', '18:07:57', 'Andres', '192.168.1.14', 'Se logeo al sistema', 'Login'),
(208, 1, 1000, '2024-11-08', '18:09:44', 'Andres', '192.168.1.14', 'Se logeo al sistema', 'Login'),
(209, 1, 1000, '2024-11-08', '18:12:09', 'Andres', '192.168.1.14', 'Se logeo al sistema', 'Login'),
(210, 1, 1000, '2024-11-08', '23:30:18', 'Andres', '192.168.1.14', 'Se logeo al sistema', 'Login');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_bodegas`
--

CREATE TABLE `tbl_bodegas` (
  `Pk_ID_BODEGA` int(11) NOT NULL,
  `NOMBRE_BODEGA` varchar(100) NOT NULL,
  `UBICACION` varchar(255) NOT NULL,
  `CAPACIDAD` int(11) NOT NULL,
  `FECHA_REGISTRO` date DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_bodegas`
--

INSERT INTO `tbl_bodegas` (`Pk_ID_BODEGA`, `NOMBRE_BODEGA`, `UBICACION`, `CAPACIDAD`, `FECHA_REGISTRO`, `estado`) VALUES
(1, 'Bodega Central', 'Av. Principal 100', 100, '2024-10-23', 1),
(2, 'Bodega Norte', 'Calle Norte 200', 80, '2024-10-23', 1),
(3, 'Bodega Sur', 'Calle Sur 300', 60, '2024-10-23', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_caja_cliente`
--

CREATE TABLE `tbl_caja_cliente` (
  `Pk_id_caja_cliente` int(11) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `caja_cliente_nombre` varchar(150) NOT NULL,
  `Fk_id_deuda` int(11) NOT NULL,
  `caja_saldo_restante` decimal(10,2) NOT NULL DEFAULT 0.00,
  `caja_estado` tinyint(4) NOT NULL DEFAULT 1,
  `caja_fecha_registro` varchar(15) NOT NULL,
  `Fk_id_factura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_caja_proveedor`
--

CREATE TABLE `tbl_caja_proveedor` (
  `Pk_id_caja_proveedor` int(11) NOT NULL,
  `Fk_id_proveedor` int(11) NOT NULL,
  `caja_proveedor_nombre` varchar(150) NOT NULL,
  `Fk_id_deuda` int(11) NOT NULL,
  `caja_saldo_restante` decimal(10,2) NOT NULL DEFAULT 0.00,
  `caja_estado` tinyint(4) NOT NULL DEFAULT 1,
  `caja_fecha_registro` varchar(150) NOT NULL,
  `Fk_id_factura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_chofer`
--

CREATE TABLE `tbl_chofer` (
  `Pk_id_chofer` int(11) NOT NULL,
  `nombreEmpresa` varchar(100) NOT NULL,
  `numeroIdentificacion` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `licencia` varchar(20) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cierre_produccion`
--

CREATE TABLE `tbl_cierre_produccion` (
  `pk_id_cierre` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `saldo_anterior` decimal(10,2) NOT NULL,
  `cargos_mes` decimal(10,2) NOT NULL,
  `abonos_mes` decimal(10,2) NOT NULL,
  `saldo_actual` decimal(10,2) NOT NULL,
  `cargos_acumulados` decimal(10,2) NOT NULL,
  `abonos_acumulados` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_clasificacionlista`
--

CREATE TABLE `tbl_clasificacionlista` (
  `pk_id_clasificacion` int(11) NOT NULL,
  `nombre_clasificacion` varchar(50) NOT NULL,
  `descripcion_clasificacion` varchar(100) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_clientes`
--

CREATE TABLE `tbl_clientes` (
  `Pk_id_cliente` int(11) NOT NULL,
  `Clientes_nombre` varchar(100) NOT NULL,
  `Clientes_apellido` varchar(100) NOT NULL,
  `Clientes_nit` varchar(20) NOT NULL,
  `Clientes_telefon` varchar(20) NOT NULL,
  `Clientes_direccion` varchar(255) NOT NULL,
  `Clientes_No_Cuenta` varchar(255) NOT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_clientes`
--

INSERT INTO `tbl_clientes` (`Pk_id_cliente`, `Clientes_nombre`, `Clientes_apellido`, `Clientes_nit`, `Clientes_telefon`, `Clientes_direccion`, `Clientes_No_Cuenta`, `estado`) VALUES
(1, 'Joise', 'Veron', '170520', '35223450', '1212ave ', '45121', 1),
(3, 'Andres', 'Veron', '4500012', '32451010', 'asd', '45121', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cobrador`
--

CREATE TABLE `tbl_cobrador` (
  `Pk_id_cobrador` int(11) NOT NULL,
  `Fk_id_empleado` int(11) NOT NULL,
  `cobrador_nombre` varchar(150) NOT NULL,
  `cobrador_direccion` varchar(150) NOT NULL,
  `cobrador_telefono` int(11) NOT NULL,
  `cobrador_depto` varchar(150) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_comisiones_encabezado`
--

CREATE TABLE `tbl_comisiones_encabezado` (
  `Pk_id_comisionEnc` int(11) NOT NULL,
  `Fk_id_vendedor` int(11) NOT NULL,
  `Comisiones_fecha_` date NOT NULL,
  `Comisiones_total_venta` decimal(10,2) NOT NULL,
  `Comisiones_total_comision` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_configuracion`
--

CREATE TABLE `tbl_configuracion` (
  `Pk_id_config` int(11) NOT NULL,
  `mes` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `metodo` varchar(10) NOT NULL,
  `Pk_id_cuenta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_consultainteligente`
--

CREATE TABLE `tbl_consultainteligente` (
  `Pk_consultaID` int(11) NOT NULL,
  `nombre_consulta` varchar(50) NOT NULL,
  `tipo_consulta` int(1) NOT NULL,
  `consulta_SQLE` varchar(100) NOT NULL,
  `consulta_estatus` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_consultainteligente`
--

INSERT INTO `tbl_consultainteligente` (`Pk_consultaID`, `nombre_consulta`, `tipo_consulta`, `consulta_SQLE`, `consulta_estatus`) VALUES
(1, '', 0, 'SELECT id_venta FROM venta;', 1),
(2, '', 0, 'SELECT SELECT id_venta FROM venta;id_venta AS * FROM venta;', 1),
(3, '', 0, 'SELECT * FROM venta;', 1),
(4, '', 0, 'SELECT * FROM venta;', 1),
(5, '', 0, 'SELECT * FROM venta;', 1),
(6, '', 0, 'SELECT * FROM venta;', 1),
(7, 'dsf', 0, 'SELECT * FROM venta;', 1),
(8, '', 0, 'SELECT * FROM venta;', 1),
(9, '', 0, 'SELECT * FROM venta;', 1),
(10, 'viccccccccc', 0, 'SELECT * FROM venta;', 1),
(11, 'consultaaaaa', 0, 'SELECT * FROM factura;', 1),
(12, '', 0, 'SELECT * FROM factura;', 1),
(13, 'jkjkkjk', 0, 'SELECT * FROM factura;', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_contabilidad`
--

CREATE TABLE `tbl_contabilidad` (
  `Pk_id_contabilidad` int(11) NOT NULL,
  `Contabilidad_tipo_registro` varchar(50) NOT NULL,
  `Contabilidad_descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_contratos`
--

CREATE TABLE `tbl_contratos` (
  `pk_id_contrato` int(11) NOT NULL,
  `contratos_fecha_creacion` date NOT NULL,
  `contratos_salario` decimal(10,2) NOT NULL,
  `contratos_tipo_contrato` varchar(35) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_control_anticipos`
--

CREATE TABLE `tbl_control_anticipos` (
  `pk_registro_anticipos` int(11) NOT NULL,
  `anticipos_cantidad` decimal(10,2) DEFAULT NULL,
  `anticipos_descripcion` varchar(50) DEFAULT NULL,
  `anticipos_mes` varchar(25) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_control_faltas`
--

CREATE TABLE `tbl_control_faltas` (
  `pk_registro_faltas` int(11) NOT NULL,
  `faltas_fecha_falta` date DEFAULT NULL,
  `faltas_mes` varchar(25) DEFAULT NULL,
  `faltas_justificacion` varchar(25) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_conversiones`
--

CREATE TABLE `tbl_conversiones` (
  `id_conversion` int(11) NOT NULL,
  `unidad_origen` varchar(50) NOT NULL,
  `unidad_destino` varchar(50) NOT NULL,
  `factor_conversion` decimal(10,6) NOT NULL,
  `tipo_conversion` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cotizacion_detalle`
--

CREATE TABLE `tbl_cotizacion_detalle` (
  `Fk_id_cotizacionEnc` varchar(20) NOT NULL,
  `Fk_id_producto` int(11) DEFAULT NULL,
  `CotizacionDet_cantidad` int(11) DEFAULT NULL,
  `CotizacionDet_precio` decimal(10,2) DEFAULT NULL,
  `CotizacionDet_subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cotizacion_encabezado`
--

CREATE TABLE `tbl_cotizacion_encabezado` (
  `Pk_id_cotizacionEnc` varchar(20) NOT NULL,
  `Fk_id_vendedor` int(11) DEFAULT NULL,
  `Fk_id_cliente` int(11) DEFAULT NULL,
  `CotizacionEnc_fechaVenc` date DEFAULT NULL,
  `CotizacionEnc_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cuentabancaria`
--

CREATE TABLE `tbl_cuentabancaria` (
  `pk_cuenta_id` int(11) NOT NULL,
  `fk_banco_id` int(11) NOT NULL,
  `cuenta_numero` varchar(20) NOT NULL,
  `cuenta_saldo` decimal(10,2) NOT NULL,
  `cuenta_tipo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cuentas`
--

CREATE TABLE `tbl_cuentas` (
  `Pk_id_cuenta` int(11) NOT NULL,
  `Pk_id_tipocuenta` int(11) NOT NULL,
  `Pk_id_encabezadocuenta` int(11) NOT NULL,
  `nombre_cuenta` varchar(50) NOT NULL,
  `cargo_mes` float DEFAULT 0,
  `abono_mes` float DEFAULT 0,
  `saldo_ant` float DEFAULT 0,
  `saldo_act` float DEFAULT 0,
  `cargo_acumulado` float DEFAULT 0,
  `abono_acumulado` float DEFAULT 0,
  `Pk_id_cuenta_enlace` int(11) DEFAULT NULL,
  `es_efectivo` tinyint(4) DEFAULT 0,
  `estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_cuentas`
--

INSERT INTO `tbl_cuentas` (`Pk_id_cuenta`, `Pk_id_tipocuenta`, `Pk_id_encabezadocuenta`, `nombre_cuenta`, `cargo_mes`, `abono_mes`, `saldo_ant`, `saldo_act`, `cargo_acumulado`, `abono_acumulado`, `Pk_id_cuenta_enlace`, `es_efectivo`, `estado`) VALUES
(1, 1, 1, 'Activo', 0, 0, 0, 0, 0, 0, NULL, 1, 1),
(2, 1, 1, 'Activo Corriente', 0, 0, 0, 0, 0, 0, 1, 1, 1),
(3, 2, 1, 'Caja', 0, 0, 0, 0, 0, 0, 2, 1, 1),
(4, 1, 1, 'Bancos', 0, 0, 0, 0, 0, 0, 2, 1, 1),
(5, 2, 1, 'Banco Industrial', 0, 0, 0, 0, 0, 0, 4, 1, 1),
(6, 2, 1, 'Banco G&T Continental', 0, 0, 0, 0, 0, 0, 4, 1, 1),
(7, 2, 1, 'Banco Agromercantil', 0, 0, 0, 0, 0, 0, 4, 1, 1),
(8, 1, 1, 'Cuentas por Cobrar', 0, 0, 0, 0, 0, 0, 2, 0, 1),
(9, 2, 1, 'Clientes', 0, 0, 0, 0, 0, 0, 8, 0, 1),
(10, 2, 1, 'Deudores Diversos', 0, 0, 0, 0, 0, 0, 8, 0, 1),
(11, 2, 1, 'Documentos por Cobrar', 0, 0, 0, 0, 0, 0, 8, 0, 1),
(12, 2, 1, 'Activos Fijos', 0, 0, 0, 0, 0, 0, 1, 0, 1),
(13, 2, 1, 'Propiedades', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(14, 2, 1, 'Maquinaria', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(15, 2, 1, 'Equipo de Oficina', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(16, 2, 1, 'Vehículos', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(17, 2, 1, 'Terrenos', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(18, 2, 1, 'Construcciones en Proceso', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(19, 2, 1, 'Inversiones a Largo Plazo', 0, 0, 0, 0, 0, 0, 2, 0, 1),
(20, 2, 1, 'Instrumentos Financieros a Largo Plazo', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(21, 1, 1, 'Inventarios', 0, 0, 0, 0, 0, 0, 2, 0, 1),
(22, 2, 1, 'Inventario de Productos Terminados', 0, 0, 0, 0, 0, 0, 21, 0, 1),
(23, 2, 1, 'Inventario de Materia Prima', 0, 0, 0, 0, 0, 0, 21, 0, 1),
(24, 1, 1, 'Inversiones a Corto Plazo', 0, 0, 0, 0, 0, 0, 2, 0, 1),
(25, 2, 1, 'Instrumentos Financieros', 0, 0, 0, 0, 0, 0, 24, 0, 1),
(26, 2, 1, 'Fondos Mutuos', 0, 0, 0, 0, 0, 0, 24, 0, 1),
(27, 2, 1, 'Acciones y Participaciones', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(28, 1, 1, 'Intangibles', 0, 0, 0, 0, 0, 0, 2, 0, 1),
(29, 2, 1, 'Patentes', 0, 0, 0, 0, 0, 0, 28, 0, 1),
(30, 2, 1, 'Marcas Registradas', 0, 0, 0, 0, 0, 0, 28, 0, 1),
(31, 2, 1, 'Créditos Comerciales', 0, 0, 0, 0, 0, 0, 8, 0, 1),
(32, 2, 1, 'Anticipos a Proveedores', 0, 0, 0, 0, 0, 0, 8, 0, 1),
(33, 2, 1, 'Propiedades en Leasing', 0, 0, 0, 0, 0, 0, 12, 0, 1),
(34, 2, 1, 'Inversiones Financieras', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(35, 2, 1, 'Depósitos a Plazo Fijo', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(36, 2, 1, 'Cuentas por Cobrar a Largo Plazo', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(37, 2, 1, 'Préstamos a Empleados', 0, 0, 0, 0, 0, 0, 19, 0, 1),
(38, 1, 1, 'Valores y Bonos', 0, 0, 0, 0, 0, 0, 24, 0, 1),
(39, 2, 1, 'Acciones en Subsidiarias', 0, 0, 0, 0, 0, 0, 24, 0, 1),
(40, 2, 1, 'Fideicomisos', 0, 0, 0, 0, 0, 0, 24, 0, 1),
(41, 1, 1, 'Activos No Corrientes', 0, 0, 0, 0, 0, 0, 1, 0, 1),
(42, 2, 1, 'Terrenos', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(43, 2, 1, 'Edificios', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(44, 2, 1, 'Maquinaria', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(45, 2, 1, 'Equipo de Transporte', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(46, 2, 1, 'Mobiliario y Equipo', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(47, 2, 1, 'Equipos de Cómputo', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(48, 1, 1, 'Intangibles', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(49, 2, 1, 'Patentes y Marcas', 0, 0, 0, 0, 0, 0, 48, 0, 1),
(50, 2, 1, 'Depreciación Acumulada', 0, 0, 0, 0, 0, 0, 41, 0, 1),
(51, 1, 2, 'Pasivo', 0, 0, 0, 0, 0, 0, NULL, 1, 1),
(52, 1, 2, 'Pasivo Corriente', 0, 0, 0, 0, 0, 0, 51, 1, 1),
(53, 1, 2, 'Cuentas por Pagar', 0, 0, 0, 0, 0, 0, 52, 1, 1),
(54, 2, 2, 'Proveedores', 0, 0, 0, 0, 0, 0, 53, 1, 1),
(55, 2, 2, 'Acreedores Diversos', 0, 0, 0, 0, 0, 0, 53, 0, 1),
(56, 2, 2, 'Documentos por Pagar', 0, 0, 0, 0, 0, 0, 53, 0, 1),
(57, 2, 2, 'Préstamos Bancarios a Corto Plazo', 0, 0, 0, 0, 0, 0, 52, 1, 1),
(58, 2, 2, 'Obligaciones por Pagar', 0, 0, 0, 0, 0, 0, 52, 0, 1),
(59, 2, 2, 'Anticipos de Clientes', 0, 0, 0, 0, 0, 0, 52, 0, 1),
(60, 1, 2, 'Impuestos por Pagar', 0, 0, 0, 0, 0, 0, 52, 1, 1),
(61, 2, 2, 'IVA por Pagar', 0, 0, 0, 0, 0, 0, 60, 0, 1),
(62, 2, 2, 'ISR por Pagar', 0, 0, 0, 0, 0, 0, 60, 0, 1),
(63, 2, 2, 'Sueldos por Pagar', 0, 0, 0, 0, 0, 0, 52, 0, 1),
(64, 2, 2, 'Retenciones por Pagar', 0, 0, 0, 0, 0, 0, 52, 0, 1),
(65, 2, 2, 'Provisiones de Bonos', 0, 0, 0, 0, 0, 0, 52, 0, 1),
(66, 1, 2, 'Pasivo No Corriente', 0, 0, 0, 0, 0, 0, 51, 0, 1),
(67, 2, 2, 'Préstamos Bancarios a Largo Plazo', 0, 0, 0, 0, 0, 0, 66, 1, 1),
(68, 2, 2, 'Obligaciones Financieras', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(69, 2, 2, 'Cuentas por Pagar a Largo Plazo', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(70, 2, 2, 'Bonos por Pagar', 0, 0, 0, 0, 0, 0, 66, 1, 1),
(71, 2, 2, 'Obligaciones Laborales', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(72, 2, 2, 'Pasivos Diferidos', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(73, 2, 2, 'Provisiones para Contingencias', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(74, 2, 2, 'Arrendamientos por Pagar', 0, 0, 0, 0, 0, 0, 66, 0, 1),
(75, 2, 2, 'Créditos Hipotecarios', 0, 0, 0, 0, 0, 0, 66, 1, 1),
(78, 1, 3, 'Capital', 0, 0, 0, 0, 0, 0, NULL, 0, 1),
(79, 2, 3, 'Capital Social', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(80, 2, 3, 'Reservas', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(81, 2, 3, 'Ganancias Retenidas', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(82, 2, 3, 'Resultados del Ejercicio', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(83, 2, 3, 'Capital Adicional', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(84, 2, 3, 'Ajustes de Capital', 0, 0, 0, 0, 0, 0, 78, 0, 1),
(85, 1, 4, 'Ingresos', 0, 0, 0, 0, 0, 0, NULL, 0, 1),
(86, 2, 4, 'Ventas de Productos', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(87, 2, 4, 'Servicios de Consultoría', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(88, 2, 4, 'Comisiones de Venta', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(89, 2, 4, 'Renta de Equipos', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(90, 2, 4, 'Honorarios Profesionales', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(91, 2, 4, 'Ingresos por Licencias y Regalías', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(92, 2, 4, 'Intereses Ganados', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(93, 2, 4, 'Ventas de Mercadería', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(94, 2, 4, 'Ventas Internacionales', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(95, 2, 4, 'Ingresos por Publicidad', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(96, 2, 4, 'Servicios de Capacitación', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(97, 2, 4, 'Consultoría de TI', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(98, 2, 4, 'Suscripciones', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(99, 2, 4, 'Renta de Propiedades', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(100, 2, 4, 'Donaciones', 0, 0, 0, 0, 0, 0, 85, 1, 1),
(101, 1, 5, 'Egresos', 0, 0, 0, 0, 0, 0, NULL, 1, 1),
(102, 2, 5, 'Sueldos y Salarios', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(103, 2, 5, 'IGSS', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(104, 2, 5, 'Horas Extras', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(105, 2, 5, 'Anticipos', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(106, 2, 5, 'Faltas', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(107, 2, 5, 'Bono 14', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(108, 2, 5, 'Aguinaldo', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(109, 2, 5, 'Vacaciones', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(110, 2, 5, 'Alquileres', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(111, 2, 5, 'Servicios Públicos', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(112, 2, 5, 'Mantenimiento y Reparaciones', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(113, 2, 5, 'Gastos de Viaje', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(114, 2, 5, 'Seguros', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(115, 2, 5, 'Depreciación de Activos', 0, 0, 0, 0, 0, 0, 101, 1, 1),
(116, 2, 5, 'Otros Gastos', 0, 0, 0, 0, 0, 0, 101, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_datos_pedido`
--

CREATE TABLE `tbl_datos_pedido` (
  `Pk_id_guia` int(11) NOT NULL,
  `fechaEmision` date NOT NULL,
  `fechaTraslado` date NOT NULL,
  `direccionPartida` varchar(255) NOT NULL,
  `direccionLlegada` varchar(255) NOT NULL,
  `numeroOrdenRecojo` varchar(20) DEFAULT NULL,
  `formaPago` varchar(50) NOT NULL,
  `destino` varchar(255) NOT NULL,
  `Fk_id_remitente` int(11) NOT NULL,
  `Fk_id_destinatario` int(11) NOT NULL,
  `Fk_id_vehiculo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_dedu_perp`
--

CREATE TABLE `tbl_dedu_perp` (
  `pk_dedu_perp` int(11) NOT NULL,
  `dedu_perp_clase` varchar(25) DEFAULT NULL,
  `dedu_perp_concepto` varchar(25) DEFAULT NULL,
  `dedu_perp_tipo` varchar(25) DEFAULT NULL,
  `dedu_perp_aplicacion` varchar(25) DEFAULT NULL,
  `dedu_perp_excepcion` tinyint(1) DEFAULT NULL,
  `dedu_perp_monto` float DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_dedu_perp`
--

INSERT INTO `tbl_dedu_perp` (`pk_dedu_perp`, `dedu_perp_clase`, `dedu_perp_concepto`, `dedu_perp_tipo`, `dedu_perp_aplicacion`, `dedu_perp_excepcion`, `dedu_perp_monto`, `estado`) VALUES
(1, 'Deduccion', 'Faltas', 'Porcentaje', 'Todos', 0, 20, 1),
(2, 'Percepcion', 'Anticipo', 'Monto', 'Todos', 0, 1, 1),
(3, 'Percepcion', 'Horas Extras', 'Monto', 'Todos', 0, 1, 1),
(4, 'Bono 14', 'Bono 14', 'Porcentaje', 'Todos', 0, 0.0833, 1),
(5, 'Aguinaldo', 'Aguinaldo', 'Porcentaje', 'Todos', 0, 0.0833, 1),
(6, 'Vacaciones', 'Vacaciones', 'Porcentaje', 'Todos', 0, 0.0575, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_dedu_perp_emp`
--

CREATE TABLE `tbl_dedu_perp_emp` (
  `pk_dedu_perp_emp` int(11) NOT NULL,
  `Fk_clave_empleado` int(11) NOT NULL,
  `Fk_dedu_perp` int(11) NOT NULL,
  `dedu_perp_emp_cantidad` float DEFAULT NULL,
  `dedu_perp_emp_mes` varchar(25) NOT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_departamentos`
--

CREATE TABLE `tbl_departamentos` (
  `pk_id_departamento` int(11) NOT NULL,
  `departamentos_nombre_departamento` varchar(50) DEFAULT NULL,
  `departamentos_descripcion` varchar(50) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_departamentos`
--

INSERT INTO `tbl_departamentos` (`pk_id_departamento`, `departamentos_nombre_departamento`, `departamentos_descripcion`, `estado`) VALUES
(1, 'Recursos Humanos', 'Departamento de Recursos Humanos', 1),
(2, 'Tecnología', 'Departamento de Tecnología', 1),
(3, 'Finanzas', 'Departamento de Finanzas', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_depreciacion_activofijo`
--

CREATE TABLE `tbl_depreciacion_activofijo` (
  `Pk_Id_Depreciacion` int(11) NOT NULL,
  `Pk_Id_ActivoFijo` int(11) NOT NULL,
  `Nombre_Activo` varchar(100) NOT NULL,
  `Tipo_Activo` varchar(50) NOT NULL,
  `Encargado` varchar(100) DEFAULT NULL,
  `Departamento` varchar(100) DEFAULT NULL,
  `Fecha_Depreciacion` date DEFAULT NULL,
  `Depreciacion` decimal(10,2) DEFAULT NULL,
  `Depreciacion_Fiscal` decimal(10,2) DEFAULT NULL,
  `Descripcion` varchar(255) DEFAULT NULL,
  `Estado` tinyint(4) DEFAULT NULL,
  `Pk_Id_Cuenta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_destinatario`
--

CREATE TABLE `tbl_destinatario` (
  `Pk_id_destinatario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `numeroIdentificacion` varchar(20) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `correoElectronico` varchar(100) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_detalleordenescompra`
--

CREATE TABLE `tbl_detalleordenescompra` (
  `FK_encOrCom_numeroOC` varchar(20) NOT NULL,
  `FK_codigoProducto` int(11) NOT NULL,
  `DetOrCom_precioU` decimal(10,2) DEFAULT NULL,
  `DetOrCom_cantidad` int(11) NOT NULL,
  `DetOrCom_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_detalle_comisiones`
--

CREATE TABLE `tbl_detalle_comisiones` (
  `Pk_id_detalle_comision` int(11) NOT NULL,
  `Fk_id_comisionEnc` int(11) NOT NULL,
  `Fk_id_facturaEnc` varchar(20) NOT NULL,
  `Comisiones_porcentaje` decimal(5,2) NOT NULL,
  `Comisiones_monto_venta` decimal(10,2) NOT NULL,
  `Comisiones_monto_comision` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_detalle_presupuesto`
--

CREATE TABLE `tbl_detalle_presupuesto` (
  `Pk_id_detalle` int(11) NOT NULL,
  `Fk_id_presupuesto` int(11) DEFAULT NULL,
  `Fk_id_cuenta` int(11) DEFAULT NULL,
  `mes_enero` decimal(18,2) DEFAULT NULL,
  `mes_febrero` decimal(18,2) DEFAULT NULL,
  `mes_marzo` decimal(18,2) DEFAULT NULL,
  `mes_abril` decimal(18,2) DEFAULT NULL,
  `mes_mayo` decimal(18,2) DEFAULT NULL,
  `mes_junio` decimal(18,2) DEFAULT NULL,
  `mes_julio` decimal(18,2) DEFAULT NULL,
  `mes_agosto` decimal(18,2) DEFAULT NULL,
  `mes_septiembre` decimal(18,2) DEFAULT NULL,
  `mes_octubre` decimal(18,2) DEFAULT NULL,
  `mes_noviembre` decimal(18,2) DEFAULT NULL,
  `mes_diciembre` decimal(18,2) DEFAULT NULL,
  `total_cuenta` decimal(18,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_deudas_clientes`
--

CREATE TABLE `tbl_deudas_clientes` (
  `Pk_id_deuda` int(11) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `Fk_id_cobrador` int(11) NOT NULL,
  `deuda_monto` decimal(10,2) NOT NULL,
  `deuda_fecha_inicio_deuda` varchar(255) NOT NULL,
  `deuda_fecha_vencimiento_deuda` varchar(255) NOT NULL,
  `deuda_descripcion_deuda` varchar(255) DEFAULT NULL,
  `deuda_estado` tinyint(4) NOT NULL DEFAULT 1,
  `transaccion_tipo` varchar(150) NOT NULL,
  `Efecto_trans` varchar(150) NOT NULL,
  `Fk_id_factura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_deudas_proveedores`
--

CREATE TABLE `tbl_deudas_proveedores` (
  `Pk_id_deuda` int(11) NOT NULL,
  `Fk_id_proveedor` int(11) NOT NULL,
  `deuda_monto` decimal(10,2) NOT NULL,
  `deuda_fecha_inicio` date NOT NULL,
  `deuda_fecha_vencimiento` date NOT NULL,
  `deuda_descripcion` varchar(255) DEFAULT NULL,
  `deuda_estado` tinyint(4) NOT NULL DEFAULT 1,
  `transaccion_tipo` varchar(150) NOT NULL,
  `Efecto_trans` varchar(150) NOT NULL,
  `Fk_id_factura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_empleados`
--

CREATE TABLE `tbl_empleados` (
  `pk_clave` int(11) NOT NULL,
  `empleados_nombre` varchar(50) NOT NULL,
  `empleados_apellido` varchar(50) DEFAULT NULL,
  `empleados_fecha_nacimiento` date DEFAULT NULL,
  `empleados_no_identificacion` varchar(50) NOT NULL,
  `empleados_codigo_postal` varchar(50) DEFAULT NULL,
  `empleados_fecha_alta` date DEFAULT NULL,
  `empleados_fecha_baja` date DEFAULT NULL,
  `empleados_causa_baja` varchar(50) DEFAULT NULL,
  `fk_id_departamento` int(11) NOT NULL,
  `fk_id_puestos` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_empleados`
--

INSERT INTO `tbl_empleados` (`pk_clave`, `empleados_nombre`, `empleados_apellido`, `empleados_fecha_nacimiento`, `empleados_no_identificacion`, `empleados_codigo_postal`, `empleados_fecha_alta`, `empleados_fecha_baja`, `empleados_causa_baja`, `fk_id_departamento`, `fk_id_puestos`, `estado`) VALUES
(1, 'Luis', 'García', '1985-06-15', '12345678', '01001', '2022-01-15', NULL, NULL, 1, 1, 1),
(2, 'María', 'Rodríguez', '1990-08-23', '87654321', '01002', '2021-04-10', NULL, NULL, 2, 2, 1),
(3, 'Carlos', 'Pérez', '1980-03-30', '56789012', '01003', '2019-11-25', '2023-09-30', 'Retiro voluntario', 3, 3, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_empresas`
--

CREATE TABLE `tbl_empresas` (
  `empresa_id` int(11) NOT NULL,
  `empresas_nombre` varchar(255) NOT NULL,
  `empresas_logo` longblob DEFAULT NULL,
  `empresas_fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `empresas_direccion` varchar(255) DEFAULT NULL,
  `empresas_telefono` varchar(20) DEFAULT NULL,
  `empresas_email` varchar(100) DEFAULT NULL,
  `empresas_pagina_web` varchar(100) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_encabezadoclasecuenta`
--

CREATE TABLE `tbl_encabezadoclasecuenta` (
  `Pk_id_encabezadocuenta` int(11) NOT NULL,
  `nombre_tipocuenta` varchar(50) NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_encabezadoclasecuenta`
--

INSERT INTO `tbl_encabezadoclasecuenta` (`Pk_id_encabezadocuenta`, `nombre_tipocuenta`, `estado`) VALUES
(1, 'Activos', 1),
(2, 'Pasivos', 1),
(3, 'Patrimonio', 1),
(4, 'Ingresos', 1),
(5, 'Gastos', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_encabezadoordencompra`
--

CREATE TABLE `tbl_encabezadoordencompra` (
  `PK_encOrCom_numeroOC` varchar(20) NOT NULL,
  `Fk_prov_id` int(11) DEFAULT NULL,
  `EncOrCom_fechaEntrega` date DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_existencias_bodega`
--

CREATE TABLE `tbl_existencias_bodega` (
  `Pk_ID_EXISTENCIA` int(11) NOT NULL,
  `Fk_ID_BODEGA` int(11) NOT NULL,
  `Fk_ID_PRODUCTO` int(11) NOT NULL,
  `CANTIDAD_ACTUAL` int(11) NOT NULL,
  `CANTIDAD_INICIAL` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_existencias_bodega`
--

INSERT INTO `tbl_existencias_bodega` (`Pk_ID_EXISTENCIA`, `Fk_ID_BODEGA`, `Fk_ID_PRODUCTO`, `CANTIDAD_ACTUAL`, `CANTIDAD_INICIAL`) VALUES
(1, 1, 1, 20, 20),
(2, 1, 2, 15, 15),
(3, 2, 3, 10, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_explosion`
--

CREATE TABLE `tbl_explosion` (
  `pk_id_explosion` int(11) NOT NULL,
  `fk_id_orden` int(11) DEFAULT NULL,
  `fk_id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `costo_total` decimal(10,2) DEFAULT NULL,
  `duracion_horas` int(11) DEFAULT NULL,
  `fk_id_proceso` int(11) DEFAULT NULL,
  `fecha_explosion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_factura`
--

CREATE TABLE `tbl_factura` (
  `Pk_id_factura` int(11) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `Fk_id_pedidoEnc` int(11) NOT NULL,
  `factura_fecha` date NOT NULL,
  `factura_formPago` varchar(20) NOT NULL,
  `factura_subtotal` decimal(10,2) NOT NULL,
  `factura_iva` decimal(10,2) NOT NULL,
  `factura_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_factura`
--

INSERT INTO `tbl_factura` (`Pk_id_factura`, `Fk_id_cliente`, `Fk_id_pedidoEnc`, `factura_fecha`, `factura_formPago`, `factura_subtotal`, `factura_iva`, `factura_total`) VALUES
(1, 1, 2, '2024-11-05', 'Efectivo', 1200.00, 12.00, 1344.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_factura_detalle`
--

CREATE TABLE `tbl_factura_detalle` (
  `fk_id_facturaEnc` varchar(20) NOT NULL,
  `Fk_id_producto` int(11) DEFAULT NULL,
  `facturaDet_cantidad` int(11) DEFAULT NULL,
  `facturaDet_precio` decimal(10,2) DEFAULT NULL,
  `facturaDet_subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_factura_encabezado`
--

CREATE TABLE `tbl_factura_encabezado` (
  `Pk_id_facturaEnc` varchar(20) NOT NULL,
  `Fk_id_vendedor` int(11) DEFAULT NULL,
  `Fk_id_cliente` int(11) DEFAULT NULL,
  `Fk_id_PeidoEnc` int(11) DEFAULT NULL,
  `CotizacionEnc_fechaCrea` date DEFAULT NULL,
  `CotizacionEnc_fechaVenc` date DEFAULT NULL,
  `factura_formPago` enum('al contado','al crédito') NOT NULL,
  `factura_subtotal` decimal(10,2) NOT NULL,
  `factura_iva` decimal(4,2) NOT NULL DEFAULT 0.12,
  `facturaEnc_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_historial_servicio`
--

CREATE TABLE `tbl_historial_servicio` (
  `Pk_Id_HistorialServicio` int(11) NOT NULL,
  `Pk_Id_ActivoFijo` int(11) NOT NULL,
  `Compania_Asegurada` varchar(100) NOT NULL,
  `Agente_Seguro` varchar(100) NOT NULL,
  `Tel_Siniestro` varchar(20) NOT NULL,
  `Tipo_Cobertura` varchar(50) NOT NULL,
  `Monto_Asegurado` decimal(10,2) NOT NULL,
  `Prima_Total` decimal(10,2) NOT NULL,
  `Deducible` decimal(10,2) NOT NULL,
  `Vigencia` date NOT NULL,
  `Fecha_Util` date NOT NULL,
  `Costo_Servicio` decimal(10,2) NOT NULL,
  `Periodo_Servicio` int(11) NOT NULL,
  `Prox_Servicio` date NOT NULL,
  `Estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_historico_cuentas`
--

CREATE TABLE `tbl_historico_cuentas` (
  `Pk_id_cuenta` int(11) NOT NULL,
  `mes` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `cargo_mes` float DEFAULT 0,
  `abono_mes` float DEFAULT 0,
  `saldo_ant` float DEFAULT 0,
  `saldo_act` float DEFAULT 0,
  `cargo_acumulado` float DEFAULT 0,
  `abono_acumulado` float DEFAULT 0,
  `saldoanual` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_historico_cuentas`
--

INSERT INTO `tbl_historico_cuentas` (`Pk_id_cuenta`, `mes`, `anio`, `cargo_mes`, `abono_mes`, `saldo_ant`, `saldo_act`, `cargo_acumulado`, `abono_acumulado`, `saldoanual`) VALUES
(1, 1, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 2, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 3, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 4, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 5, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 6, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 7, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 8, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 9, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(1, 10, 2024, 100, 100, 500, 1500, 800, 1000, 10000),
(2, 1, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 2, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 3, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 4, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 5, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 6, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 7, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 8, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 9, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(2, 10, 2024, 150, 150, 1000, 3000, 800, 1000, 20000),
(3, 1, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 2, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 3, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 4, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 5, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 6, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 7, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 8, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 9, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(3, 10, 2024, 75, 75, 700, 2200, 800, 1000, 15000),
(4, 1, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 2, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 3, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 4, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 5, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 6, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 7, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 8, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 9, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(4, 10, 2024, 0, 100, 3000, 2500, 800, 1000, 10000),
(5, 1, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 2, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 3, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 4, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 5, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 6, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 7, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 8, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 9, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(5, 10, 2024, 50, 50, 1200, 500, 800, 1000, 5000),
(6, 1, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 2, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 3, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 4, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 5, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 6, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 7, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 8, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 9, 2024, 25, 25, 0, 5000, 800, 1000, 20000),
(6, 10, 2024, 25, 25, 0, 5000, 800, 1000, 20000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_horas_extra`
--

CREATE TABLE `tbl_horas_extra` (
  `pk_registro_horas` int(11) NOT NULL,
  `horas_mes` varchar(25) DEFAULT NULL,
  `horas_cantidad_horas` int(11) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_identidadactivo`
--

CREATE TABLE `tbl_identidadactivo` (
  `Pk_Id_Identidad` int(11) NOT NULL,
  `Nombre_Identidad` varchar(50) NOT NULL,
  `Estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_implosion`
--

CREATE TABLE `tbl_implosion` (
  `pk_id_implosion` int(11) NOT NULL,
  `fk_id_orden` int(11) DEFAULT NULL,
  `fk_id_producto_final` int(11) DEFAULT NULL,
  `id_componente` varchar(50) DEFAULT NULL,
  `cantidad_componente` int(11) DEFAULT NULL,
  `costo_componente` int(11) DEFAULT NULL,
  `duracion_horas` int(11) DEFAULT NULL,
  `fk_id_proceso` int(11) DEFAULT NULL,
  `fecha_implosion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_linea`
--

CREATE TABLE `tbl_linea` (
  `Pk_id_linea` int(11) NOT NULL,
  `nombre_linea` varchar(50) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `fk_id_marca` int(11) DEFAULT NULL,
  `comision` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_liquidacion_trabajadores`
--

CREATE TABLE `tbl_liquidacion_trabajadores` (
  `pk_registro_liquidacion` int(11) NOT NULL,
  `liquidacion_aguinaldo` decimal(10,2) NOT NULL,
  `liquidacion_bono_14` decimal(10,2) NOT NULL,
  `liquidacion_vacaciones` decimal(10,2) NOT NULL,
  `liquidacion_tipo_operacion` varchar(25) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_lista_detalle`
--

CREATE TABLE `tbl_lista_detalle` (
  `Fk_id_lista_Encabezado` int(11) NOT NULL,
  `Fk_id_Producto` int(11) NOT NULL,
  `ListDetalle_precio` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_lista_encabezado`
--

CREATE TABLE `tbl_lista_encabezado` (
  `Pk_id_lista_Encabezado` int(11) NOT NULL,
  `Fk_id_clasificacion` int(11) DEFAULT NULL,
  `ListEncabezado_fecha` date DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_locales`
--

CREATE TABLE `tbl_locales` (
  `Pk_ID_LOCAL` int(11) NOT NULL,
  `NOMBRE_LOCAL` varchar(100) NOT NULL,
  `UBICACION` varchar(255) NOT NULL,
  `CAPACIDAD` int(11) NOT NULL,
  `ESTADO` tinyint(4) NOT NULL DEFAULT 1,
  `FECHA_REGISTRO` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_lotes_detalles`
--

CREATE TABLE `tbl_lotes_detalles` (
  `Pk_id_lotes_detalle` int(11) NOT NULL,
  `Fk_id_producto` int(11) DEFAULT NULL,
  `Fk_id_lote` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_lotes_encabezado`
--

CREATE TABLE `tbl_lotes_encabezado` (
  `Pk_id_lote` int(11) NOT NULL,
  `codigo_lote` varchar(100) DEFAULT NULL,
  `Fecha_Producción` date DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `Fk_id_proceso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_mantenimiento`
--

CREATE TABLE `tbl_mantenimiento` (
  `Pk_id_Mantenimiento` int(11) NOT NULL,
  `nombre_Solicitante` varchar(20) NOT NULL,
  `tipo_de_Mantenimiento` varchar(15) NOT NULL,
  `componente_Afectado` varchar(15) NOT NULL,
  `fecha` date NOT NULL,
  `responsable_Asignado` varchar(20) NOT NULL,
  `codigo_Error_Problema` varchar(50) NOT NULL,
  `estado_del_Mantenimiento` varchar(20) NOT NULL,
  `tiempo_Estimado` varchar(30) NOT NULL,
  `Fk_id_vehiculo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_mantenimientos`
--

CREATE TABLE `tbl_mantenimientos` (
  `Pk_id_maquinaria` int(11) NOT NULL,
  `nombre_maquinaria` varchar(255) DEFAULT NULL,
  `tipo_maquina` varchar(255) DEFAULT NULL,
  `hora_operacion` decimal(10,2) DEFAULT NULL,
  `mantenimiento_periodico` varchar(100) DEFAULT NULL,
  `ultima_mantenimiento` date DEFAULT NULL,
  `proximo_mantenimiento` date DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `desgaste_porcentaje` decimal(10,2) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `fk_id_maquina` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_maquinaria`
--

CREATE TABLE `tbl_maquinaria` (
  `pk_id_maquina` int(11) NOT NULL,
  `nombre_maquina` varchar(100) NOT NULL,
  `tipo_maquina` varchar(50) NOT NULL,
  `capacidad_produccion` decimal(10,2) NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_marca`
--

CREATE TABLE `tbl_marca` (
  `Pk_id_Marca` int(11) NOT NULL,
  `nombre_Marca` varchar(50) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `fk_id_Producto` int(11) DEFAULT NULL,
  `comision` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_modulos`
--

CREATE TABLE `tbl_modulos` (
  `Pk_id_modulos` int(11) NOT NULL,
  `nombre_modulo` varchar(50) NOT NULL,
  `descripcion_modulo` varchar(150) NOT NULL,
  `estado_modulo` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_modulos`
--

INSERT INTO `tbl_modulos` (`Pk_id_modulos`, `nombre_modulo`, `descripcion_modulo`, `estado_modulo`) VALUES
(1000, 'SEGURIDAD', 'Seguridad', 1),
(2000, 'LOGISTICA', 'Logistica', 1),
(3000, 'COMPRAS Y VENTAS', 'Compras y Ventas', 1),
(5000, 'PRODUCCIÓN', 'Produccion', 1),
(6000, 'NOMINAS', 'Nominas', 1),
(7000, 'BANCOS', 'Bancos', 1),
(8000, 'CONTABILIDAD', 'Contabilidad', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_mora_clientes`
--

CREATE TABLE `tbl_mora_clientes` (
  `Pk_id_mora` int(11) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `Fk_id_transaccion` int(11) NOT NULL,
  `morafecha` varchar(15) NOT NULL,
  `mora_monto` decimal(10,2) NOT NULL,
  `mora_dias` int(11) NOT NULL,
  `mora_estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_movimiento`
--

CREATE TABLE `tbl_movimiento` (
  `Pk_id_movimiento` int(11) NOT NULL,
  `Movimiento_codigo` varchar(50) NOT NULL,
  `Movimiento_cuenta` varchar(50) NOT NULL,
  `Movimiento_tipo` varchar(20) NOT NULL,
  `Movimiento_valor` decimal(10,2) NOT NULL,
  `Movimiento_cargos` decimal(10,2) NOT NULL,
  `Movimiento_abonos` decimal(10,2) NOT NULL,
  `Fk_id_poliza` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_movimientobancario`
--

CREATE TABLE `tbl_movimientobancario` (
  `pk_movimientobancario_id` int(11) NOT NULL,
  `fk_cuenta_id` int(11) NOT NULL,
  `movimientobancario_fecha` date NOT NULL,
  `movimientobancario_tipo` varchar(50) NOT NULL,
  `movimientobancario_monto` decimal(10,2) NOT NULL,
  `movimientobancario_descripcion` text DEFAULT NULL,
  `movimientobancario_metodo_pago` varchar(50) DEFAULT NULL,
  `movimientobancario_estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_movimiento_de_inventario`
--

CREATE TABLE `tbl_movimiento_de_inventario` (
  `Pk_id_movimiento` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `Fk_id_producto` int(11) NOT NULL,
  `Fk_id_stock` int(11) NOT NULL,
  `Fk_ID_LOCALES` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_ordenes_produccion`
--

CREATE TABLE `tbl_ordenes_produccion` (
  `Pk_id_orden` int(11) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_ordenes_produccion_detalle`
--

CREATE TABLE `tbl_ordenes_produccion_detalle` (
  `Pk_id_detalle` int(11) NOT NULL,
  `Fk_id_orden` int(11) NOT NULL,
  `Fk_id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_pedido_detalle`
--

CREATE TABLE `tbl_pedido_detalle` (
  `Fk_id_pedidoEnc` varchar(20) NOT NULL,
  `Fk_id_producto` int(11) NOT NULL,
  `Fk_id_cotizacionEnc` varchar(20) NOT NULL,
  `PedidoDet_cantidad` int(11) DEFAULT NULL,
  `PedidoEnc_precio` decimal(10,2) DEFAULT NULL,
  `PedidoEnc_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_pedido_encabezado`
--

CREATE TABLE `tbl_pedido_encabezado` (
  `Pk_id_PedidoEnc` varchar(20) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `Fk_id_vendedor` int(11) NOT NULL,
  `PedidoEncfecha` date NOT NULL,
  `PedidoEnc_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_perfiles`
--

CREATE TABLE `tbl_perfiles` (
  `Pk_id_perfil` int(11) NOT NULL,
  `nombre_perfil` varchar(50) NOT NULL,
  `descripcion_perfil` varchar(150) NOT NULL,
  `estado_perfil` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_perfiles`
--

INSERT INTO `tbl_perfiles` (`Pk_id_perfil`, `nombre_perfil`, `descripcion_perfil`, `estado_perfil`) VALUES
(1, 'ADMINISTRADOR', 'contiene todos los permisos del programa', 1),
(2, 'SEGURIDAD', 'contiene todos los permisos de seguridad', 1),
(3, 'LOGISTICA', 'contiene todos los permisos de logistica', 1),
(4, 'COMPRAS Y VENTAS', 'contiene todos los permisos de compras y ventas', 1),
(5, 'PRODUCCIÓN', 'contiene todos los permisos de producción', 1),
(6, 'NOMINAS', 'contiene todos los permisos de nominas', 1),
(7, 'BANCOS', 'contiene todos los permisos de bancos', 1),
(8, 'CONTABILIDAD', 'contiene todos los permisos de contabilidad', 1),
(9, 'AUDITOR', 'Permite la revisión y auditoría de actividades sin capacidad de modificar datos', 1),
(10, 'SOporte Técnico', 'Permite brindar asistencia técnica sin acceso completo a la administración', 1),
(11, 'ADMINISTRADOR', 'Acceso completo al sistema con ciertas restricciones según sea necesario', 1),
(12, 'GESTOR DE PROYECTOS', 'Permite gestionar proyectos y coordinar actividades sin acceso completo a la administración', 1),
(13, 'GESTOR DE DATOS', 'Permite gestionar y supervisar datos en distintos módulos sin acceso completo a la administración', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_permisos_aplicaciones_usuario`
--

CREATE TABLE `tbl_permisos_aplicaciones_usuario` (
  `PK_id_Aplicacion_Usuario` int(11) NOT NULL,
  `Fk_id_usuario` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `guardar_permiso` tinyint(1) DEFAULT 0,
  `buscar_permiso` tinyint(1) DEFAULT 0,
  `modificar_permiso` tinyint(1) DEFAULT 0,
  `eliminar_permiso` tinyint(1) DEFAULT 0,
  `imprimir_permiso` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_permisos_aplicaciones_usuario`
--

INSERT INTO `tbl_permisos_aplicaciones_usuario` (`PK_id_Aplicacion_Usuario`, `Fk_id_usuario`, `Fk_id_aplicacion`, `guardar_permiso`, `buscar_permiso`, `modificar_permiso`, `eliminar_permiso`, `imprimir_permiso`) VALUES
(1, 1, 1002, 1, 1, 1, 1, 0),
(2, 1, 2000, 0, 0, 0, 0, 0),
(3, 1, 1000, 1, 1, 1, 1, 1),
(4, 1, 8000, 0, 0, 0, 0, 0),
(6, 1, 1000, 1, 1, 1, 1, 1),
(7, 1, 1000, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_permisos_aplicacion_perfil`
--

CREATE TABLE `tbl_permisos_aplicacion_perfil` (
  `PK_id_Aplicacion_Perfil` int(11) NOT NULL,
  `Fk_id_perfil` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `guardar_permiso` tinyint(1) DEFAULT 0,
  `modificar_permiso` tinyint(1) DEFAULT 0,
  `eliminar_permiso` tinyint(1) DEFAULT 0,
  `buscar_permiso` tinyint(1) DEFAULT 0,
  `imprimir_permiso` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tbl_permisos_aplicacion_perfil`
--

INSERT INTO `tbl_permisos_aplicacion_perfil` (`PK_id_Aplicacion_Perfil`, `Fk_id_perfil`, `Fk_id_aplicacion`, `guardar_permiso`, `modificar_permiso`, `eliminar_permiso`, `buscar_permiso`, `imprimir_permiso`) VALUES
(1, 1, 1000, 1, 1, 1, 1, 1),
(2, 1, 1001, 1, 1, 1, 1, 1),
(3, 1, 1002, 1, 1, 1, 1, 1),
(4, 1, 1003, 1, 1, 1, 1, 1),
(5, 1, 1004, 1, 1, 1, 1, 1),
(6, 1, 1101, 1, 1, 1, 1, 1),
(7, 1, 1102, 1, 1, 1, 1, 1),
(8, 1, 1103, 1, 1, 1, 1, 1),
(9, 1, 1201, 1, 1, 1, 1, 1),
(10, 1, 1301, 1, 1, 1, 1, 1),
(11, 1, 2000, 1, 1, 1, 1, 1),
(12, 1, 3000, 1, 1, 1, 1, 1),
(13, 1, 5000, 1, 1, 1, 1, 1),
(14, 1, 6000, 1, 1, 1, 1, 1),
(15, 1, 6001, 1, 1, 1, 1, 1),
(16, 1, 6002, 1, 1, 1, 1, 1),
(17, 1, 6003, 1, 1, 1, 1, 1),
(18, 1, 6004, 1, 1, 1, 1, 1),
(19, 1, 6005, 1, 1, 1, 1, 1),
(20, 1, 6006, 1, 1, 1, 1, 1),
(21, 1, 6007, 1, 1, 1, 1, 1),
(22, 1, 6101, 1, 1, 1, 1, 1),
(23, 1, 6102, 1, 1, 1, 1, 1),
(24, 1, 6103, 1, 1, 1, 1, 1),
(25, 1, 6104, 1, 1, 1, 1, 1),
(26, 1, 6105, 1, 1, 1, 1, 1),
(27, 1, 6106, 1, 1, 1, 1, 1),
(28, 1, 6201, 1, 1, 1, 1, 1),
(29, 1, 6202, 1, 1, 1, 1, 1),
(30, 1, 6203, 1, 1, 1, 1, 1),
(31, 1, 6301, 1, 1, 1, 1, 1),
(32, 1, 7000, 1, 1, 1, 1, 1),
(33, 1, 8000, 1, 1, 1, 1, 1),
(34, 2, 1000, 1, 1, 1, 1, 1),
(35, 3, 2000, 1, 1, 1, 1, 1),
(36, 4, 3000, 1, 1, 1, 1, 1),
(37, 5, 5000, 1, 1, 1, 1, 1),
(38, 6, 6000, 1, 1, 1, 1, 1),
(39, 6, 6001, 1, 1, 1, 1, 1),
(40, 6, 6002, 1, 1, 1, 1, 1),
(41, 6, 6003, 1, 1, 1, 1, 1),
(42, 6, 6004, 1, 1, 1, 1, 1),
(43, 6, 6005, 1, 1, 1, 1, 1),
(44, 6, 6006, 1, 1, 1, 1, 1),
(45, 6, 6007, 1, 1, 1, 1, 1),
(46, 6, 6101, 1, 1, 1, 1, 1),
(47, 6, 6102, 1, 1, 1, 1, 1),
(48, 6, 6103, 1, 1, 1, 1, 1),
(49, 6, 6104, 1, 1, 1, 1, 1),
(50, 6, 6105, 1, 1, 1, 1, 1),
(51, 6, 6106, 1, 1, 1, 1, 1),
(52, 6, 6201, 1, 1, 1, 1, 1),
(53, 6, 6202, 1, 1, 1, 1, 1),
(54, 6, 6203, 1, 1, 1, 1, 1),
(55, 6, 6301, 1, 1, 1, 1, 1),
(56, 7, 7000, 1, 1, 1, 1, 1),
(57, 8, 8000, 1, 1, 1, 1, 1),
(58, 9, 1000, 1, 1, 1, 1, 1),
(59, 9, 1001, 1, 1, 1, 1, 1),
(60, 9, 1002, 1, 1, 1, 1, 1),
(61, 9, 1003, 1, 1, 1, 1, 1),
(62, 9, 1004, 1, 1, 1, 1, 1),
(63, 9, 1101, 1, 1, 1, 1, 1),
(64, 9, 1102, 1, 1, 1, 1, 1),
(65, 9, 1103, 1, 1, 1, 1, 1),
(66, 9, 1201, 1, 1, 1, 1, 1),
(67, 9, 1301, 1, 1, 1, 1, 1),
(68, 9, 2000, 1, 1, 1, 1, 1),
(69, 9, 3000, 1, 1, 1, 1, 1),
(70, 9, 5000, 1, 1, 1, 1, 1),
(71, 9, 6000, 1, 1, 1, 1, 1),
(72, 9, 6001, 1, 1, 1, 1, 1),
(73, 9, 6002, 1, 1, 1, 1, 1),
(74, 9, 6003, 1, 1, 1, 1, 1),
(75, 9, 6004, 1, 1, 1, 1, 1),
(76, 9, 6005, 1, 1, 1, 1, 1),
(77, 9, 6006, 1, 1, 1, 1, 1),
(78, 9, 6007, 1, 1, 1, 1, 1),
(79, 9, 6101, 1, 1, 1, 1, 1),
(80, 9, 6102, 1, 1, 1, 1, 1),
(81, 9, 6103, 1, 1, 1, 1, 1),
(82, 9, 6104, 1, 1, 1, 1, 1),
(83, 9, 6105, 1, 1, 1, 1, 1),
(84, 9, 6106, 1, 1, 1, 1, 1),
(85, 9, 6201, 1, 1, 1, 1, 1),
(86, 9, 6202, 1, 1, 1, 1, 1),
(87, 9, 6203, 1, 1, 1, 1, 1),
(88, 9, 6301, 1, 1, 1, 1, 1),
(89, 9, 7000, 1, 1, 1, 1, 1),
(90, 9, 8000, 1, 1, 1, 1, 1),
(91, 10, 1000, 1, 1, 1, 1, 1),
(92, 10, 1001, 1, 1, 1, 1, 1),
(93, 10, 1002, 1, 1, 1, 1, 1),
(94, 10, 1003, 1, 1, 1, 1, 1),
(95, 10, 1004, 1, 1, 1, 1, 1),
(96, 10, 1101, 1, 1, 1, 1, 1),
(97, 10, 1102, 1, 1, 1, 1, 1),
(98, 10, 1103, 1, 1, 1, 1, 1),
(99, 10, 1201, 1, 1, 1, 1, 1),
(100, 10, 1301, 1, 1, 1, 1, 1),
(101, 10, 2000, 1, 1, 1, 1, 1),
(102, 10, 3000, 1, 1, 1, 1, 1),
(103, 10, 5000, 1, 1, 1, 1, 1),
(104, 10, 6000, 1, 1, 1, 1, 1),
(105, 10, 6001, 1, 1, 1, 1, 1),
(106, 10, 6002, 1, 1, 1, 1, 1),
(107, 10, 6003, 1, 1, 1, 1, 1),
(108, 10, 6004, 1, 1, 1, 1, 1),
(109, 10, 6005, 1, 1, 1, 1, 1),
(110, 10, 6006, 1, 1, 1, 1, 1),
(111, 10, 6007, 1, 1, 1, 1, 1),
(112, 10, 6101, 1, 1, 1, 1, 1),
(113, 10, 6102, 1, 1, 1, 1, 1),
(114, 10, 6103, 1, 1, 1, 1, 1),
(115, 10, 6104, 1, 1, 1, 1, 1),
(116, 10, 6105, 1, 1, 1, 1, 1),
(117, 10, 6106, 1, 1, 1, 1, 1),
(118, 10, 6201, 1, 1, 1, 1, 1),
(119, 10, 6202, 1, 1, 1, 1, 1),
(120, 10, 6203, 1, 1, 1, 1, 1),
(121, 10, 6301, 1, 1, 1, 1, 1),
(122, 10, 7000, 1, 1, 1, 1, 1),
(123, 10, 8000, 1, 1, 1, 1, 1),
(124, 11, 1000, 1, 1, 1, 1, 1),
(125, 11, 1001, 1, 1, 1, 1, 1),
(126, 11, 1002, 1, 1, 1, 1, 1),
(127, 11, 1003, 1, 1, 1, 1, 1),
(128, 11, 1004, 1, 1, 1, 1, 1),
(129, 11, 1101, 1, 1, 1, 1, 1),
(130, 11, 1102, 1, 1, 1, 1, 1),
(131, 11, 1103, 1, 1, 1, 1, 1),
(132, 11, 1201, 1, 1, 1, 1, 1),
(133, 11, 1301, 1, 1, 1, 1, 1),
(134, 11, 2000, 1, 1, 1, 1, 1),
(135, 11, 3000, 1, 1, 1, 1, 1),
(136, 11, 5000, 1, 1, 1, 1, 1),
(137, 11, 6000, 1, 1, 1, 1, 1),
(138, 11, 6001, 1, 1, 1, 1, 1),
(139, 11, 6002, 1, 1, 1, 1, 1),
(140, 11, 6003, 1, 1, 1, 1, 1),
(141, 11, 6004, 1, 1, 1, 1, 1),
(142, 11, 6005, 1, 1, 1, 1, 1),
(143, 11, 6006, 1, 1, 1, 1, 1),
(144, 11, 6007, 1, 1, 1, 1, 1),
(145, 11, 6101, 1, 1, 1, 1, 1),
(146, 11, 6102, 1, 1, 1, 1, 1),
(147, 11, 6103, 1, 1, 1, 1, 1),
(148, 11, 6104, 1, 1, 1, 1, 1),
(149, 11, 6105, 1, 1, 1, 1, 1),
(150, 11, 6106, 1, 1, 1, 1, 1),
(151, 11, 6201, 1, 1, 1, 1, 1),
(152, 11, 6202, 1, 1, 1, 1, 1),
(153, 11, 6203, 1, 1, 1, 1, 1),
(154, 11, 6301, 1, 1, 1, 1, 1),
(155, 11, 7000, 1, 1, 1, 1, 1),
(156, 11, 8000, 1, 1, 1, 1, 1),
(157, 12, 1000, 1, 1, 1, 1, 1),
(158, 12, 1001, 1, 1, 1, 1, 1),
(159, 12, 1002, 1, 1, 1, 1, 1),
(160, 12, 1003, 1, 1, 1, 1, 1),
(161, 12, 1004, 1, 1, 1, 1, 1),
(162, 12, 1101, 1, 1, 1, 1, 1),
(163, 12, 1102, 1, 1, 1, 1, 1),
(164, 12, 1103, 1, 1, 1, 1, 1),
(165, 12, 1201, 1, 1, 1, 1, 1),
(166, 12, 1301, 1, 1, 1, 1, 1),
(167, 12, 2000, 1, 1, 1, 1, 1),
(168, 12, 3000, 1, 1, 1, 1, 1),
(169, 12, 5000, 1, 1, 1, 1, 1),
(170, 12, 6000, 1, 1, 1, 1, 1),
(171, 12, 6001, 1, 1, 1, 1, 1),
(172, 12, 6002, 1, 1, 1, 1, 1),
(173, 12, 6003, 1, 1, 1, 1, 1),
(174, 12, 6004, 1, 1, 1, 1, 1),
(175, 12, 6005, 1, 1, 1, 1, 1),
(176, 12, 6006, 1, 1, 1, 1, 1),
(177, 12, 6007, 1, 1, 1, 1, 1),
(178, 12, 6101, 1, 1, 1, 1, 1),
(179, 12, 6102, 1, 1, 1, 1, 1),
(180, 12, 6103, 1, 1, 1, 1, 1),
(181, 12, 6104, 1, 1, 1, 1, 1),
(182, 12, 6105, 1, 1, 1, 1, 1),
(183, 12, 6106, 1, 1, 1, 1, 1),
(184, 12, 6201, 1, 1, 1, 1, 1),
(185, 12, 6202, 1, 1, 1, 1, 1),
(186, 12, 6203, 1, 1, 1, 1, 1),
(187, 12, 6301, 1, 1, 1, 1, 1),
(188, 12, 7000, 1, 1, 1, 1, 1),
(189, 12, 8000, 1, 1, 1, 1, 1),
(190, 13, 1000, 1, 1, 1, 1, 1),
(191, 13, 1001, 1, 1, 1, 1, 1),
(192, 13, 1002, 1, 1, 1, 1, 1),
(193, 13, 1003, 1, 1, 1, 1, 1),
(194, 13, 1004, 1, 1, 1, 1, 1),
(195, 13, 1101, 1, 1, 1, 1, 1),
(196, 13, 1102, 1, 1, 1, 1, 1),
(197, 13, 1103, 1, 1, 1, 1, 1),
(198, 13, 1201, 1, 1, 1, 1, 1),
(199, 13, 1301, 1, 1, 1, 1, 1),
(200, 13, 2000, 1, 1, 1, 1, 1),
(201, 13, 3000, 1, 1, 1, 1, 1),
(202, 13, 5000, 1, 1, 1, 1, 1),
(203, 13, 6000, 1, 1, 1, 1, 1),
(204, 13, 6001, 1, 1, 1, 1, 1),
(205, 13, 6002, 1, 1, 1, 1, 1),
(206, 13, 6003, 1, 1, 1, 1, 1),
(207, 13, 6004, 1, 1, 1, 1, 1),
(208, 13, 6005, 1, 1, 1, 1, 1),
(209, 13, 6006, 1, 1, 1, 1, 1),
(210, 13, 6007, 1, 1, 1, 1, 1),
(211, 13, 6101, 1, 1, 1, 1, 1),
(212, 13, 6102, 1, 1, 1, 1, 1),
(213, 13, 6103, 1, 1, 1, 1, 1),
(214, 13, 6104, 1, 1, 1, 1, 1),
(215, 13, 6105, 1, 1, 1, 1, 1),
(216, 13, 6106, 1, 1, 1, 1, 1),
(217, 13, 6201, 1, 1, 1, 1, 1),
(218, 13, 6202, 1, 1, 1, 1, 1),
(219, 13, 6203, 1, 1, 1, 1, 1),
(220, 13, 6301, 1, 1, 1, 1, 1),
(221, 13, 7000, 1, 1, 1, 1, 1),
(222, 13, 8000, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_planilla_detalle`
--

CREATE TABLE `tbl_planilla_detalle` (
  `pk_registro_planilla_Detalle` int(11) NOT NULL,
  `detalle_total_Percepciones` decimal(10,2) DEFAULT NULL,
  `detalle_total_Deducciones` decimal(10,2) DEFAULT NULL,
  `detalle_total_liquido` decimal(10,2) DEFAULT NULL,
  `fk_clave_empleado` int(11) NOT NULL,
  `fk_id_contrato` int(11) NOT NULL,
  `fk_id_registro_planilla_Encabezado` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_planilla_encabezado`
--

CREATE TABLE `tbl_planilla_encabezado` (
  `pk_registro_planilla_Encabezado` int(11) NOT NULL,
  `encabezado_correlativo_planilla` int(11) NOT NULL,
  `encabezado_fecha_inicio` date DEFAULT NULL,
  `encabezado_fecha_final` date DEFAULT NULL,
  `encabezado_total_mes` decimal(10,2) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_poliza`
--

CREATE TABLE `tbl_poliza` (
  `Pk_id_poliza` int(11) NOT NULL,
  `Poliza_fecha_emision` date NOT NULL,
  `Poliza_concepto` varchar(255) NOT NULL,
  `Poliza_docto` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_polizadetalle`
--

CREATE TABLE `tbl_polizadetalle` (
  `Pk_id_polizadetalle` int(11) NOT NULL,
  `Pk_id_polizaencabezado` int(11) NOT NULL,
  `Pk_id_cuenta` int(11) NOT NULL,
  `Pk_id_tipooperacion` int(11) NOT NULL,
  `valor` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_polizaencabezado`
--

CREATE TABLE `tbl_polizaencabezado` (
  `Pk_id_polizaencabezado` int(11) NOT NULL,
  `fechaPoliza` varchar(50) DEFAULT NULL,
  `concepto` varchar(65) DEFAULT NULL,
  `Pk_id_tipopoliza` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_poliza_contabilidad`
--

CREATE TABLE `tbl_poliza_contabilidad` (
  `Fk_id_poliza` int(11) NOT NULL,
  `Fk_id_contabilidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_poliza_rango_fechas`
--

CREATE TABLE `tbl_poliza_rango_fechas` (
  `Fk_id_poliza` int(11) NOT NULL,
  `Fk_id_rango` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_presupuesto`
--

CREATE TABLE `tbl_presupuesto` (
  `Pk_id_presupuesto` int(11) NOT NULL,
  `nombre_presupuesto` varchar(100) DEFAULT NULL,
  `ejercicio_presupuesto` int(11) DEFAULT NULL,
  `fecha_creacion` date DEFAULT NULL,
  `total_presupuesto` decimal(18,2) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_proceso_produccion_detalle`
--

CREATE TABLE `tbl_proceso_produccion_detalle` (
  `Pk_id_proceso_detalle` int(11) NOT NULL,
  `Fk_id_productos` int(11) DEFAULT NULL,
  `Fk_id_receta` int(11) DEFAULT NULL,
  `Fk_id_empleado` int(11) DEFAULT NULL,
  `Fk_id_proceso` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `costo_u` decimal(10,2) DEFAULT NULL,
  `costo_t` decimal(10,2) DEFAULT NULL,
  `duracion_horas` decimal(10,2) DEFAULT NULL,
  `mano_de_obra` decimal(10,2) DEFAULT NULL,
  `costo_luz` decimal(10,2) DEFAULT NULL,
  `costo_agua` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_proceso_produccion_encabezado`
--

CREATE TABLE `tbl_proceso_produccion_encabezado` (
  `Pk_id_proceso` int(11) NOT NULL,
  `Fk_id_orden` int(11) DEFAULT NULL,
  `Fk_id_maquinaria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_productos`
--

CREATE TABLE `tbl_productos` (
  `Pk_id_Producto` int(11) NOT NULL,
  `codigoProducto` int(11) NOT NULL,
  `nombreProducto` varchar(30) NOT NULL,
  `pesoProducto` varchar(20) DEFAULT NULL,
  `precioUnitario` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL,
  `costo_compra` decimal(10,2) DEFAULT NULL,
  `clasificacion` varchar(30) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `stock` int(11) NOT NULL,
  `empaque` varchar(50) NOT NULL,
  `Fk_id_receta` int(11) DEFAULT NULL,
  `comisionInventario` double NOT NULL,
  `comisionCosto` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_productos`
--

INSERT INTO `tbl_productos` (`Pk_id_Producto`, `codigoProducto`, `nombreProducto`, `pesoProducto`, `precioUnitario`, `precio_venta`, `costo_compra`, `clasificacion`, `estado`, `stock`, `empaque`, `Fk_id_receta`, `comisionInventario`, `comisionCosto`) VALUES
(1, 1001, 'Colchón Queen', '20 kg', 250.00, NULL, NULL, 'Dormitorio', 1, 100, 'Caja', NULL, 0.1, 0.2),
(2, 1002, 'Colchón King', '25 kg', 350.00, NULL, NULL, 'Dormitorio', 1, 50, 'Caja', NULL, 0.15, 0.2),
(3, 1003, 'Sofá 3 Plazas', '80 kg', 500.00, NULL, NULL, 'Sala', 1, 30, 'Desarmado', NULL, 0.1, 0.2),
(4, 1004, 'Almohada Visc.', '1 kg', 30.00, NULL, NULL, 'Accesorios', 1, 200, 'Bolsa', NULL, 0.15, 0.3),
(5, 1005, 'Mesa de Centro', '25 kg', 120.00, NULL, NULL, 'Sala', 1, 60, 'Desarmado', NULL, 0.1, 0.25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_proveedores`
--

CREATE TABLE `tbl_proveedores` (
  `Pk_prov_id` int(11) NOT NULL,
  `Prov_nombre` varchar(100) NOT NULL,
  `Prov_direccion` varchar(255) DEFAULT NULL,
  `Prov_telefono` varchar(20) DEFAULT NULL,
  `Prov_email` varchar(100) DEFAULT NULL,
  `Prov_fechaRegistro` date DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_puestos_trabajo`
--

CREATE TABLE `tbl_puestos_trabajo` (
  `pk_id_puestos` int(11) NOT NULL,
  `puestos_nombre_puesto` varchar(50) DEFAULT NULL,
  `puestos_descripcion` varchar(50) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_puestos_trabajo`
--

INSERT INTO `tbl_puestos_trabajo` (`pk_id_puestos`, `puestos_nombre_puesto`, `puestos_descripcion`, `estado`) VALUES
(1, 'Gerente', 'Gerente General', 1),
(2, 'Analista', 'Analista de Datos', 1),
(3, 'Desarrollador', 'Desarrollador de Software', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_rango_fechas`
--

CREATE TABLE `tbl_rango_fechas` (
  `Pk_id_rango` int(11) NOT NULL,
  `Rango_fecha_inicio` date NOT NULL,
  `Rango_fecha_fin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_recetas`
--

CREATE TABLE `tbl_recetas` (
  `Pk_id_receta` int(11) NOT NULL,
  `Fk_id_producto` int(11) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `cama` varchar(100) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_receta_detalle`
--

CREATE TABLE `tbl_receta_detalle` (
  `Pk_id_detalle` int(11) NOT NULL,
  `Fk_id_receta` int(11) NOT NULL,
  `Fk_id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_regreporteria`
--

CREATE TABLE `tbl_regreporteria` (
  `idregistro` int(11) NOT NULL,
  `ruta` varchar(500) NOT NULL,
  `nombre_archivo` varchar(45) NOT NULL,
  `aplicacion` varchar(45) NOT NULL,
  `estado` varchar(45) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `Fk_id_modulos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_remitente`
--

CREATE TABLE `tbl_remitente` (
  `Pk_id_remitente` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `numeroIdentificacion` varchar(20) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `correoElectronico` varchar(100) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_rrhh_produccion`
--

CREATE TABLE `tbl_rrhh_produccion` (
  `id_empleado` int(11) NOT NULL,
  `salario` decimal(10,2) NOT NULL,
  `dias` int(11) NOT NULL,
  `total_dias` decimal(10,2) NOT NULL,
  `horas` int(11) NOT NULL,
  `total_horas` decimal(10,2) NOT NULL,
  `horas_extras` int(11) NOT NULL,
  `total_horas_extras` decimal(10,2) NOT NULL,
  `total_mano_obra` decimal(10,2) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `pk_id_RRHH` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipoactivofijo`
--

CREATE TABLE `tbl_tipoactivofijo` (
  `Pk_Id_TipoActivoFijo` int(11) NOT NULL,
  `Nombre_Tipo` varchar(50) NOT NULL,
  `Estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipocambio`
--

CREATE TABLE `tbl_tipocambio` (
  `pk_id_tipoCambio` int(11) NOT NULL,
  `tipoCambio_nombre_moneda` varchar(50) NOT NULL,
  `tipoCambio_valor_moneda` decimal(5,3) NOT NULL,
  `tipoCambio_valorCambio_moneda` decimal(5,3) NOT NULL,
  `tipoCambio_estatus` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipocuenta`
--

CREATE TABLE `tbl_tipocuenta` (
  `PK_id_tipocuenta` int(11) NOT NULL,
  `nombre_tipocuenta` varchar(50) NOT NULL,
  `serie_tipocuenta` varchar(50) NOT NULL,
  `estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipocuenta`
--

INSERT INTO `tbl_tipocuenta` (`PK_id_tipocuenta`, `nombre_tipocuenta`, `serie_tipocuenta`, `estado`) VALUES
(1, 'Padre', 'P', 1),
(2, 'Hija', 'H', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipooperacion`
--

CREATE TABLE `tbl_tipooperacion` (
  `Pk_id_tipooperacion` int(11) NOT NULL,
  `nombre` varchar(65) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tbl_tipooperacion`
--

INSERT INTO `tbl_tipooperacion` (`Pk_id_tipooperacion`, `nombre`, `estado`) VALUES
(1, 'Cargo', 1),
(2, 'Abono', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipopoliza`
--

CREATE TABLE `tbl_tipopoliza` (
  `Pk_id_tipopoliza` int(11) NOT NULL,
  `tipo` varchar(65) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tbl_tipopoliza`
--

INSERT INTO `tbl_tipopoliza` (`Pk_id_tipopoliza`, `tipo`, `estado`) VALUES
(2, 'Diario', 1),
(3, 'Ingreso', 1),
(4, 'Egreso', 1),
(5, 'Ajuste', 1),
(6, 'Provisión', 1),
(7, 'Transferencia', 1),
(8, 'Cancelación', 1),
(9, 'Anticipo', 1),
(10, 'Reclasificación', 1),
(11, 'Cierre de Mes', 1),
(12, 'Apertura de Ejercicio', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_transaccion`
--

CREATE TABLE `tbl_transaccion` (
  `pk_transaccion_id` int(11) NOT NULL,
  `fk_cuenta_id` int(11) NOT NULL,
  `transaccion_fecha` datetime NOT NULL,
  `transaccion_monto` decimal(10,2) NOT NULL,
  `transaccion_estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_transaccion_cliente`
--

CREATE TABLE `tbl_transaccion_cliente` (
  `Pk_id_transaccion` int(11) NOT NULL,
  `Fk_id_cliente` int(11) NOT NULL,
  `transaccion_fecha` varchar(150) NOT NULL,
  `transaccion_monto` decimal(10,2) DEFAULT NULL,
  `transaccion_tipo_moneda` varchar(100) NOT NULL,
  `transaccion_estado` tinyint(4) NOT NULL DEFAULT 1,
  `Fk_id_factura` int(11) NOT NULL,
  `Fk_id_transC` int(11) NOT NULL,
  `transaccion_tipo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_transaccion_cliente`
--

INSERT INTO `tbl_transaccion_cliente` (`Pk_id_transaccion`, `Fk_id_cliente`, `transaccion_fecha`, `transaccion_monto`, `transaccion_tipo_moneda`, `transaccion_estado`, `Fk_id_factura`, `Fk_id_transC`, `transaccion_tipo`) VALUES
(11, 1, '2024-11-08', 2000.00, 'MXN', 0, 1, 1, 'Crédito'),
(12, 3, '2024-11-08', 2000.00, 'GTQ', 0, 1, 1, 'Debito');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_transaccion_cuentas`
--

CREATE TABLE `tbl_transaccion_cuentas` (
  `Pk_id_tran_cue` int(11) NOT NULL,
  `tran_nombre` varchar(150) NOT NULL,
  `tran_efecto` varchar(15) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_transaccion_cuentas`
--

INSERT INTO `tbl_transaccion_cuentas` (`Pk_id_tran_cue`, `tran_nombre`, `tran_efecto`, `estado`) VALUES
(1, 'asdad', 'Negativo ', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_transaccion_proveedor`
--

CREATE TABLE `tbl_transaccion_proveedor` (
  `Pk_id_transaccion` int(11) NOT NULL,
  `Fk_id_proveedor` int(11) NOT NULL,
  `fecha_transaccion` varchar(150) NOT NULL,
  `transaccion_monto` decimal(10,2) DEFAULT NULL,
  `transaccion_tipo_moneda` varchar(100) NOT NULL,
  `transaccion_estado` tinyint(4) NOT NULL DEFAULT 1,
  `Fk_id_transC` int(11) NOT NULL,
  `transaccion_tipo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_trasladoproductos`
--

CREATE TABLE `tbl_trasladoproductos` (
  `Pk_id_TrasladoProductos` int(11) NOT NULL,
  `documento` varchar(50) NOT NULL,
  `fecha` datetime NOT NULL,
  `costoTotal` int(11) NOT NULL,
  `costoTotalGeneral` int(11) NOT NULL,
  `precioTotal` int(11) NOT NULL,
  `Fk_id_Producto` int(11) NOT NULL,
  `Fk_id_guia` int(11) NOT NULL,
  `codigoProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_usuarios`
--

CREATE TABLE `tbl_usuarios` (
  `Pk_id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `apellido_usuario` varchar(50) NOT NULL,
  `username_usuario` varchar(20) NOT NULL,
  `password_usuario` varchar(100) NOT NULL,
  `email_usuario` varchar(50) NOT NULL,
  `ultima_conexion_usuario` datetime DEFAULT NULL,
  `estado_usuario` tinyint(4) NOT NULL DEFAULT 0,
  `pregunta` varchar(50) NOT NULL,
  `respuesta` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_usuarios`
--

INSERT INTO `tbl_usuarios` (`Pk_id_usuario`, `nombre_usuario`, `apellido_usuario`, `username_usuario`, `password_usuario`, `email_usuario`, `ultima_conexion_usuario`, `estado_usuario`, `pregunta`, `respuesta`) VALUES
(1, 'admin', 'admin', 'admin', '52c88f064ed5ed9161d01f634f5e3bfcf5c77fec94fb398b6690e1b41178eb6c', 'esduardo@gmail.com', '2024-11-08 23:30:18', 1, 'COLOR FAVORITO', 'ROJO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_vehiculos`
--

CREATE TABLE `tbl_vehiculos` (
  `Pk_id_vehiculo` int(11) NOT NULL,
  `numeroPlaca` varchar(10) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `color` varchar(30) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `horaLlegada` datetime NOT NULL,
  `horaSalida` datetime DEFAULT NULL,
  `pesoTotal` decimal(10,2) NOT NULL,
  `Fk_id_chofer` int(11) NOT NULL,
  `Estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_vendedores`
--

CREATE TABLE `tbl_vendedores` (
  `Pk_id_vendedor` int(11) NOT NULL,
  `vendedores_nombre` varchar(100) NOT NULL,
  `vendedores_apellido` varchar(100) NOT NULL,
  `vendedores_sueldo` decimal(10,2) NOT NULL,
  `vendedores_direccion` varchar(255) NOT NULL,
  `vendedores_telefono` varchar(20) NOT NULL,
  `Fk_id_empleado` int(11) NOT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `id_venta` int(11) NOT NULL,
  `monto` int(11) NOT NULL,
  `nombre_cliente` varchar(50) NOT NULL,
  `nombre_empleado` varchar(50) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`id_venta`, `monto`, `nombre_cliente`, `nombre_empleado`, `estado`) VALUES
(1, 111, 'Josue', 'David', 1),
(2, 222, 'Fernando', 'David', 1),
(3, 100, 'Josue David', 'Joel Lopez', 1),
(4, 400, 'Sebastian', 'Victor', 1),
(5, 555, 'Brayan', 'Daniel', 1),
(6, 8888, 'pedro', 'perez', 1),
(7, 555, 'roro', 'pablo', 1),
(8, 444, 'shiro', 'rodolfo', 1),
(9, 999, 'Brayan', 'Daniel', 1),
(10, 111, 'shiro', 'sh', 1),
(11, 88, 'lol', 'lol', 1),
(12, 1111, 'lll', 'lll', 1),
(13, 1111, 'www', 'www', 1),
(14, 56456, 'wwww', 'qqq', 1),
(15, 111223, 'hola', 'hol', 1),
(16, 2222, 'yy', 'yyy', 1),
(17, 555, 'ggg', 'ggg', 1),
(18, 100, 'ahora', 'ddd', 1),
(19, 100, 'pedro', 'lucas', 1),
(20, 555, 'cliente', 'empleado', 1),
(21, 200, 'cliente', 'empleado', 1),
(22, 200, 'rrr', 'www', 1),
(23, 333, 'www', 'qqq', 1),
(24, 33, 'eee', 'xxx', 1),
(25, 600, 'ññ', 'lll', 1),
(26, 6456, 'qqq', 'fff', 1),
(27, 555, 'ddd', 'aaa', 1),
(28, 666, 'qqq', 'aaa', 1),
(29, 666, 'cliente', 'empleado', 1),
(30, 888, 'Cliente1', 'Empleado122', 1),
(31, 6666, 'ClientePrueba', 'EmpleadoPrueba', 1),
(32, 6666, 'qq', 'qqq', 1),
(33, 999, 'cliente', 'emple', 1),
(34, 333, 'cli', 'emp', 1),
(35, 65, 'pedro', 'juan', 1),
(36, 65656, 'djf', 'kjk', 1),
(37, 0, '', '', 1),
(38, 0, '', '', 1);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwaplicacionperfil`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwaplicacionperfil` (
`ID` int(11)
,`Perfil` varchar(50)
,`Aplicacion` int(11)
,`Insertar` tinyint(1)
,`Modificar` tinyint(1)
,`Eliminar` tinyint(1)
,`Buscar` tinyint(1)
,`Reporte` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwaplicacionusuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwaplicacionusuario` (
`Aplicacion` int(11)
,`ID` int(11)
,`Usuario` varchar(50)
,`Insertar` tinyint(1)
,`Editar` tinyint(1)
,`Eliminar` tinyint(1)
,`Buscar` tinyint(1)
,`Reporte` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwmoduloaplicacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwmoduloaplicacion` (
`ID` int(11)
,`Modulo` varchar(50)
,`Aplicacion` int(11)
,`Nombre` varchar(50)
,`Descripcion` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwperfilusuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwperfilusuario` (
`ID` int(11)
,`Usuario` varchar(50)
,`nickName` varchar(20)
,`perfil` int(11)
,`Nombre` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vwaplicacionperfil`
--
DROP TABLE IF EXISTS `vwaplicacionperfil`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwaplicacionperfil`  AS SELECT `b`.`Fk_id_perfil` AS `ID`, `a`.`nombre_perfil` AS `Perfil`, `b`.`Fk_id_aplicacion` AS `Aplicacion`, `b`.`guardar_permiso` AS `Insertar`, `b`.`modificar_permiso` AS `Modificar`, `b`.`eliminar_permiso` AS `Eliminar`, `b`.`buscar_permiso` AS `Buscar`, `b`.`imprimir_permiso` AS `Reporte` FROM (`tbl_permisos_aplicacion_perfil` `b` join `tbl_perfiles` `a` on(`a`.`Pk_id_perfil` = `b`.`Fk_id_perfil`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwaplicacionusuario`
--
DROP TABLE IF EXISTS `vwaplicacionusuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwaplicacionusuario`  AS SELECT `b`.`Fk_id_aplicacion` AS `Aplicacion`, `b`.`Fk_id_usuario` AS `ID`, `a`.`nombre_usuario` AS `Usuario`, `b`.`guardar_permiso` AS `Insertar`, `b`.`modificar_permiso` AS `Editar`, `b`.`eliminar_permiso` AS `Eliminar`, `b`.`buscar_permiso` AS `Buscar`, `b`.`imprimir_permiso` AS `Reporte` FROM (`tbl_permisos_aplicaciones_usuario` `b` join `tbl_usuarios` `a` on(`a`.`Pk_id_usuario` = `b`.`Fk_id_usuario`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwmoduloaplicacion`
--
DROP TABLE IF EXISTS `vwmoduloaplicacion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwmoduloaplicacion`  AS SELECT `b`.`Fk_id_modulos` AS `ID`, `a`.`nombre_modulo` AS `Modulo`, `b`.`Fk_id_aplicacion` AS `Aplicacion`, `c`.`nombre_aplicacion` AS `Nombre`, `c`.`descripcion_aplicacion` AS `Descripcion` FROM ((`tbl_asignacion_modulo_aplicacion` `b` join `tbl_modulos` `a` on(`a`.`Pk_id_modulos` = `b`.`Fk_id_modulos`)) join `tbl_aplicaciones` `c` on(`c`.`Pk_id_aplicacion` = `b`.`Fk_id_aplicacion`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwperfilusuario`
--
DROP TABLE IF EXISTS `vwperfilusuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwperfilusuario`  AS SELECT `b`.`Fk_id_usuario` AS `ID`, `a`.`nombre_usuario` AS `Usuario`, `a`.`username_usuario` AS `nickName`, `b`.`Fk_id_perfil` AS `perfil`, `c`.`nombre_perfil` AS `Nombre` FROM ((`tbl_asignaciones_perfils_usuario` `b` join `tbl_usuarios` `a` on(`a`.`Pk_id_usuario` = `b`.`Fk_id_usuario`)) join `tbl_perfiles` `c` on(`c`.`Pk_id_perfil` = `b`.`Fk_id_perfil`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ayuda`
--
ALTER TABLE `ayuda`
  ADD PRIMARY KEY (`Id_ayuda`);

--
-- Indices de la tabla `tbl_activofijo`
--
ALTER TABLE `tbl_activofijo`
  ADD PRIMARY KEY (`Pk_Id_ActivoFijo`),
  ADD UNIQUE KEY `Codigo_Activo` (`Codigo_Activo`),
  ADD KEY `Fk_TipoActivoFijo` (`Pk_Id_TipoActivoFijo`),
  ADD KEY `Fk_Identidad` (`Pk_Id_Identidad`),
  ADD KEY `Fk_Cuenta` (`Pk_Id_Cuenta`);

--
-- Indices de la tabla `tbl_aplicaciones`
--
ALTER TABLE `tbl_aplicaciones`
  ADD PRIMARY KEY (`Pk_id_aplicacion`);

--
-- Indices de la tabla `tbl_asignaciones_perfils_usuario`
--
ALTER TABLE `tbl_asignaciones_perfils_usuario`
  ADD PRIMARY KEY (`PK_id_Perfil_Usuario`),
  ADD KEY `Fk_id_usuario` (`Fk_id_usuario`),
  ADD KEY `Fk_id_perfil` (`Fk_id_perfil`);

--
-- Indices de la tabla `tbl_asignacion_modulo_aplicacion`
--
ALTER TABLE `tbl_asignacion_modulo_aplicacion`
  ADD PRIMARY KEY (`Fk_id_modulos`,`Fk_id_aplicacion`),
  ADD KEY `Fk_id_aplicacion` (`Fk_id_aplicacion`);

--
-- Indices de la tabla `tbl_asignacion_vacaciones`
--
ALTER TABLE `tbl_asignacion_vacaciones`
  ADD PRIMARY KEY (`pk_registro_vaciones`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_auditorias`
--
ALTER TABLE `tbl_auditorias`
  ADD PRIMARY KEY (`Pk_ID_AUDITORIA`),
  ADD KEY `Fk_ID_BODEGA` (`Fk_ID_BODEGA`),
  ADD KEY `Fk_ID_PRODUCTO` (`Fk_ID_PRODUCTO`);

--
-- Indices de la tabla `tbl_banco`
--
ALTER TABLE `tbl_banco`
  ADD PRIMARY KEY (`pk_banco_id`);

--
-- Indices de la tabla `tbl_bitacora`
--
ALTER TABLE `tbl_bitacora`
  ADD PRIMARY KEY (`Pk_id_bitacora`),
  ADD KEY `Fk_id_usuario` (`Fk_id_usuario`),
  ADD KEY `Fk_id_aplicacion` (`Fk_id_aplicacion`);

--
-- Indices de la tabla `tbl_bodegas`
--
ALTER TABLE `tbl_bodegas`
  ADD PRIMARY KEY (`Pk_ID_BODEGA`);

--
-- Indices de la tabla `tbl_caja_cliente`
--
ALTER TABLE `tbl_caja_cliente`
  ADD PRIMARY KEY (`Pk_id_caja_cliente`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`),
  ADD KEY `Fk_id_deuda` (`Fk_id_deuda`),
  ADD KEY `id_factura` (`Fk_id_factura`);

--
-- Indices de la tabla `tbl_caja_proveedor`
--
ALTER TABLE `tbl_caja_proveedor`
  ADD PRIMARY KEY (`Pk_id_caja_proveedor`),
  ADD KEY `Fk_id_proveedor` (`Fk_id_proveedor`),
  ADD KEY `Fk_id_deuda` (`Fk_id_deuda`),
  ADD KEY `fk_factura_caja` (`Fk_id_factura`);

--
-- Indices de la tabla `tbl_chofer`
--
ALTER TABLE `tbl_chofer`
  ADD PRIMARY KEY (`Pk_id_chofer`);

--
-- Indices de la tabla `tbl_cierre_produccion`
--
ALTER TABLE `tbl_cierre_produccion`
  ADD PRIMARY KEY (`pk_id_cierre`);

--
-- Indices de la tabla `tbl_clasificacionlista`
--
ALTER TABLE `tbl_clasificacionlista`
  ADD PRIMARY KEY (`pk_id_clasificacion`);

--
-- Indices de la tabla `tbl_clientes`
--
ALTER TABLE `tbl_clientes`
  ADD PRIMARY KEY (`Pk_id_cliente`);

--
-- Indices de la tabla `tbl_cobrador`
--
ALTER TABLE `tbl_cobrador`
  ADD PRIMARY KEY (`Pk_id_cobrador`),
  ADD KEY `Fk_id_empleado` (`Fk_id_empleado`);

--
-- Indices de la tabla `tbl_comisiones_encabezado`
--
ALTER TABLE `tbl_comisiones_encabezado`
  ADD PRIMARY KEY (`Pk_id_comisionEnc`),
  ADD KEY `Fk_id_vendedor` (`Fk_id_vendedor`);

--
-- Indices de la tabla `tbl_configuracion`
--
ALTER TABLE `tbl_configuracion`
  ADD PRIMARY KEY (`Pk_id_config`),
  ADD KEY `Pk_id_cuenta` (`Pk_id_cuenta`);

--
-- Indices de la tabla `tbl_consultainteligente`
--
ALTER TABLE `tbl_consultainteligente`
  ADD PRIMARY KEY (`Pk_consultaID`);

--
-- Indices de la tabla `tbl_contabilidad`
--
ALTER TABLE `tbl_contabilidad`
  ADD PRIMARY KEY (`Pk_id_contabilidad`);

--
-- Indices de la tabla `tbl_contratos`
--
ALTER TABLE `tbl_contratos`
  ADD PRIMARY KEY (`pk_id_contrato`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_control_anticipos`
--
ALTER TABLE `tbl_control_anticipos`
  ADD PRIMARY KEY (`pk_registro_anticipos`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_control_faltas`
--
ALTER TABLE `tbl_control_faltas`
  ADD PRIMARY KEY (`pk_registro_faltas`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_conversiones`
--
ALTER TABLE `tbl_conversiones`
  ADD PRIMARY KEY (`id_conversion`);

--
-- Indices de la tabla `tbl_cotizacion_detalle`
--
ALTER TABLE `tbl_cotizacion_detalle`
  ADD KEY `Fk_id_cotizacionEnc` (`Fk_id_cotizacionEnc`),
  ADD KEY `Fk_id_producto` (`Fk_id_producto`);

--
-- Indices de la tabla `tbl_cotizacion_encabezado`
--
ALTER TABLE `tbl_cotizacion_encabezado`
  ADD PRIMARY KEY (`Pk_id_cotizacionEnc`),
  ADD UNIQUE KEY `Pk_id_cotizacionEnc` (`Pk_id_cotizacionEnc`),
  ADD KEY `Fk_id_vendedor` (`Fk_id_vendedor`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`);

--
-- Indices de la tabla `tbl_cuentabancaria`
--
ALTER TABLE `tbl_cuentabancaria`
  ADD PRIMARY KEY (`pk_cuenta_id`),
  ADD UNIQUE KEY `cuenta_numero` (`cuenta_numero`),
  ADD KEY `fk_banco` (`fk_banco_id`);

--
-- Indices de la tabla `tbl_cuentas`
--
ALTER TABLE `tbl_cuentas`
  ADD PRIMARY KEY (`Pk_id_cuenta`,`Pk_id_tipocuenta`,`Pk_id_encabezadocuenta`),
  ADD UNIQUE KEY `Pk_id_cuenta` (`Pk_id_cuenta`),
  ADD KEY `Pk_id_tipocuenta` (`Pk_id_tipocuenta`),
  ADD KEY `Pk_id_encabezadocuenta` (`Pk_id_encabezadocuenta`),
  ADD KEY `Pk_id_cuenta_enlace` (`Pk_id_cuenta_enlace`);

--
-- Indices de la tabla `tbl_datos_pedido`
--
ALTER TABLE `tbl_datos_pedido`
  ADD PRIMARY KEY (`Pk_id_guia`),
  ADD KEY `Fk_id_remitente` (`Fk_id_remitente`),
  ADD KEY `Fk_id_destinatario` (`Fk_id_destinatario`),
  ADD KEY `Fk_id_vehiculo` (`Fk_id_vehiculo`);

--
-- Indices de la tabla `tbl_dedu_perp`
--
ALTER TABLE `tbl_dedu_perp`
  ADD PRIMARY KEY (`pk_dedu_perp`);

--
-- Indices de la tabla `tbl_dedu_perp_emp`
--
ALTER TABLE `tbl_dedu_perp_emp`
  ADD PRIMARY KEY (`pk_dedu_perp_emp`),
  ADD KEY `Fk_clave_empleado` (`Fk_clave_empleado`),
  ADD KEY `Fk_dedu_perp` (`Fk_dedu_perp`);

--
-- Indices de la tabla `tbl_departamentos`
--
ALTER TABLE `tbl_departamentos`
  ADD PRIMARY KEY (`pk_id_departamento`);

--
-- Indices de la tabla `tbl_depreciacion_activofijo`
--
ALTER TABLE `tbl_depreciacion_activofijo`
  ADD PRIMARY KEY (`Pk_Id_Depreciacion`),
  ADD KEY `Fk_IdActivoFijo_Depreciacion` (`Pk_Id_ActivoFijo`),
  ADD KEY `Fk_Cuenta_Depreciacion_New` (`Pk_Id_Cuenta`);

--
-- Indices de la tabla `tbl_destinatario`
--
ALTER TABLE `tbl_destinatario`
  ADD PRIMARY KEY (`Pk_id_destinatario`);

--
-- Indices de la tabla `tbl_detalleordenescompra`
--
ALTER TABLE `tbl_detalleordenescompra`
  ADD PRIMARY KEY (`FK_encOrCom_numeroOC`,`FK_codigoProducto`),
  ADD KEY `FK_codigoProducto` (`FK_codigoProducto`);

--
-- Indices de la tabla `tbl_detalle_comisiones`
--
ALTER TABLE `tbl_detalle_comisiones`
  ADD PRIMARY KEY (`Pk_id_detalle_comision`),
  ADD KEY `Fk_id_comisionEnc` (`Fk_id_comisionEnc`),
  ADD KEY `Fk_id_facturaEnc` (`Fk_id_facturaEnc`);

--
-- Indices de la tabla `tbl_detalle_presupuesto`
--
ALTER TABLE `tbl_detalle_presupuesto`
  ADD PRIMARY KEY (`Pk_id_detalle`),
  ADD KEY `Fk_id_presupuesto` (`Fk_id_presupuesto`),
  ADD KEY `Fk_id_cuenta` (`Fk_id_cuenta`);

--
-- Indices de la tabla `tbl_deudas_clientes`
--
ALTER TABLE `tbl_deudas_clientes`
  ADD PRIMARY KEY (`Pk_id_deuda`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`),
  ADD KEY `Fk_id_cobrador` (`Fk_id_cobrador`),
  ADD KEY `fk_id_factura` (`Fk_id_factura`);

--
-- Indices de la tabla `tbl_deudas_proveedores`
--
ALTER TABLE `tbl_deudas_proveedores`
  ADD PRIMARY KEY (`Pk_id_deuda`),
  ADD KEY `Fk_id_proveedor` (`Fk_id_proveedor`),
  ADD KEY `fk_id_factura2` (`Fk_id_factura`);

--
-- Indices de la tabla `tbl_empleados`
--
ALTER TABLE `tbl_empleados`
  ADD PRIMARY KEY (`pk_clave`),
  ADD KEY `fk_id_departamento` (`fk_id_departamento`),
  ADD KEY `fk_id_puestos` (`fk_id_puestos`);

--
-- Indices de la tabla `tbl_empresas`
--
ALTER TABLE `tbl_empresas`
  ADD PRIMARY KEY (`empresa_id`);

--
-- Indices de la tabla `tbl_encabezadoclasecuenta`
--
ALTER TABLE `tbl_encabezadoclasecuenta`
  ADD PRIMARY KEY (`Pk_id_encabezadocuenta`);

--
-- Indices de la tabla `tbl_encabezadoordencompra`
--
ALTER TABLE `tbl_encabezadoordencompra`
  ADD PRIMARY KEY (`PK_encOrCom_numeroOC`),
  ADD UNIQUE KEY `PK_encOrCom_numeroOC` (`PK_encOrCom_numeroOC`),
  ADD KEY `Fk_prov_id` (`Fk_prov_id`);

--
-- Indices de la tabla `tbl_existencias_bodega`
--
ALTER TABLE `tbl_existencias_bodega`
  ADD PRIMARY KEY (`Pk_ID_EXISTENCIA`),
  ADD KEY `FK_EXISTENCIA_BODEGA` (`Fk_ID_BODEGA`),
  ADD KEY `FK_EXISTENCIA_PRODUCTO` (`Fk_ID_PRODUCTO`);

--
-- Indices de la tabla `tbl_explosion`
--
ALTER TABLE `tbl_explosion`
  ADD PRIMARY KEY (`pk_id_explosion`),
  ADD KEY `fk_id_producto` (`fk_id_producto`),
  ADD KEY `fk_id_proceso` (`fk_id_proceso`);

--
-- Indices de la tabla `tbl_factura`
--
ALTER TABLE `tbl_factura`
  ADD PRIMARY KEY (`Pk_id_factura`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`);

--
-- Indices de la tabla `tbl_factura_detalle`
--
ALTER TABLE `tbl_factura_detalle`
  ADD KEY `fk_id_facturaEnc` (`fk_id_facturaEnc`),
  ADD KEY `Fk_id_producto` (`Fk_id_producto`);

--
-- Indices de la tabla `tbl_factura_encabezado`
--
ALTER TABLE `tbl_factura_encabezado`
  ADD PRIMARY KEY (`Pk_id_facturaEnc`),
  ADD UNIQUE KEY `Pk_id_facturaEnc` (`Pk_id_facturaEnc`),
  ADD KEY `Fk_id_vendedor` (`Fk_id_vendedor`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`);

--
-- Indices de la tabla `tbl_historial_servicio`
--
ALTER TABLE `tbl_historial_servicio`
  ADD PRIMARY KEY (`Pk_Id_HistorialServicio`),
  ADD KEY `Fk_ActivoFijo` (`Pk_Id_ActivoFijo`);

--
-- Indices de la tabla `tbl_historico_cuentas`
--
ALTER TABLE `tbl_historico_cuentas`
  ADD PRIMARY KEY (`Pk_id_cuenta`,`mes`,`anio`);

--
-- Indices de la tabla `tbl_horas_extra`
--
ALTER TABLE `tbl_horas_extra`
  ADD PRIMARY KEY (`pk_registro_horas`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_identidadactivo`
--
ALTER TABLE `tbl_identidadactivo`
  ADD PRIMARY KEY (`Pk_Id_Identidad`);

--
-- Indices de la tabla `tbl_implosion`
--
ALTER TABLE `tbl_implosion`
  ADD PRIMARY KEY (`pk_id_implosion`);

--
-- Indices de la tabla `tbl_linea`
--
ALTER TABLE `tbl_linea`
  ADD PRIMARY KEY (`Pk_id_linea`),
  ADD KEY `fk_id_marca` (`fk_id_marca`);

--
-- Indices de la tabla `tbl_liquidacion_trabajadores`
--
ALTER TABLE `tbl_liquidacion_trabajadores`
  ADD PRIMARY KEY (`pk_registro_liquidacion`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`);

--
-- Indices de la tabla `tbl_lista_detalle`
--
ALTER TABLE `tbl_lista_detalle`
  ADD PRIMARY KEY (`Fk_id_lista_Encabezado`,`Fk_id_Producto`),
  ADD KEY `fk_producto` (`Fk_id_Producto`);

--
-- Indices de la tabla `tbl_lista_encabezado`
--
ALTER TABLE `tbl_lista_encabezado`
  ADD PRIMARY KEY (`Pk_id_lista_Encabezado`),
  ADD KEY `fk_clasificacion` (`Fk_id_clasificacion`);

--
-- Indices de la tabla `tbl_locales`
--
ALTER TABLE `tbl_locales`
  ADD PRIMARY KEY (`Pk_ID_LOCAL`);

--
-- Indices de la tabla `tbl_lotes_detalles`
--
ALTER TABLE `tbl_lotes_detalles`
  ADD PRIMARY KEY (`Pk_id_lotes_detalle`),
  ADD KEY `idx_fk_producto` (`Fk_id_producto`),
  ADD KEY `idx_fk_lote` (`Fk_id_lote`);

--
-- Indices de la tabla `tbl_lotes_encabezado`
--
ALTER TABLE `tbl_lotes_encabezado`
  ADD PRIMARY KEY (`Pk_id_lote`),
  ADD KEY `idx_fk_proceso_lote_encabezado` (`Fk_id_proceso`);

--
-- Indices de la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD PRIMARY KEY (`Pk_id_Mantenimiento`),
  ADD KEY `Fk_id_vehiculo` (`Fk_id_vehiculo`);

--
-- Indices de la tabla `tbl_mantenimientos`
--
ALTER TABLE `tbl_mantenimientos`
  ADD PRIMARY KEY (`Pk_id_maquinaria`),
  ADD KEY `fk_maquina` (`fk_id_maquina`);

--
-- Indices de la tabla `tbl_maquinaria`
--
ALTER TABLE `tbl_maquinaria`
  ADD PRIMARY KEY (`pk_id_maquina`);

--
-- Indices de la tabla `tbl_marca`
--
ALTER TABLE `tbl_marca`
  ADD PRIMARY KEY (`Pk_id_Marca`),
  ADD KEY `fk_id_Producto` (`fk_id_Producto`);

--
-- Indices de la tabla `tbl_modulos`
--
ALTER TABLE `tbl_modulos`
  ADD PRIMARY KEY (`Pk_id_modulos`);

--
-- Indices de la tabla `tbl_mora_clientes`
--
ALTER TABLE `tbl_mora_clientes`
  ADD PRIMARY KEY (`Pk_id_mora`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`),
  ADD KEY `Fk_id_transaccion` (`Fk_id_transaccion`);

--
-- Indices de la tabla `tbl_movimiento`
--
ALTER TABLE `tbl_movimiento`
  ADD PRIMARY KEY (`Pk_id_movimiento`),
  ADD KEY `Fk_id_poliza` (`Fk_id_poliza`);

--
-- Indices de la tabla `tbl_movimientobancario`
--
ALTER TABLE `tbl_movimientobancario`
  ADD PRIMARY KEY (`pk_movimientobancario_id`),
  ADD KEY `fk_cuenta` (`fk_cuenta_id`);

--
-- Indices de la tabla `tbl_movimiento_de_inventario`
--
ALTER TABLE `tbl_movimiento_de_inventario`
  ADD PRIMARY KEY (`Pk_id_movimiento`),
  ADD KEY `Fk_id_producto` (`Fk_id_producto`),
  ADD KEY `Fk_id_stock` (`Fk_id_stock`),
  ADD KEY `FK_EXISTENCIA_LOCAL` (`Fk_ID_LOCALES`);

--
-- Indices de la tabla `tbl_ordenes_produccion`
--
ALTER TABLE `tbl_ordenes_produccion`
  ADD PRIMARY KEY (`Pk_id_orden`);

--
-- Indices de la tabla `tbl_ordenes_produccion_detalle`
--
ALTER TABLE `tbl_ordenes_produccion_detalle`
  ADD PRIMARY KEY (`Pk_id_detalle`),
  ADD KEY `idx_fk_orden` (`Fk_id_orden`),
  ADD KEY `idx_fk_producto` (`Fk_id_producto`);

--
-- Indices de la tabla `tbl_pedido_detalle`
--
ALTER TABLE `tbl_pedido_detalle`
  ADD PRIMARY KEY (`Fk_id_pedidoEnc`,`Fk_id_producto`,`Fk_id_cotizacionEnc`),
  ADD KEY `Fk_id_producto` (`Fk_id_producto`),
  ADD KEY `Fk_id_cotizacionEnc` (`Fk_id_cotizacionEnc`);

--
-- Indices de la tabla `tbl_pedido_encabezado`
--
ALTER TABLE `tbl_pedido_encabezado`
  ADD PRIMARY KEY (`Pk_id_PedidoEnc`),
  ADD UNIQUE KEY `Pk_id_pedidoEnc` (`Pk_id_PedidoEnc`),
  ADD UNIQUE KEY `Pk_id_PedidoEnc_2` (`Pk_id_PedidoEnc`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`),
  ADD KEY `Fk_id_vendedor` (`Fk_id_vendedor`);

--
-- Indices de la tabla `tbl_perfiles`
--
ALTER TABLE `tbl_perfiles`
  ADD PRIMARY KEY (`Pk_id_perfil`);

--
-- Indices de la tabla `tbl_permisos_aplicaciones_usuario`
--
ALTER TABLE `tbl_permisos_aplicaciones_usuario`
  ADD PRIMARY KEY (`PK_id_Aplicacion_Usuario`),
  ADD KEY `Fk_id_usuario` (`Fk_id_usuario`),
  ADD KEY `Fk_id_aplicacion` (`Fk_id_aplicacion`);

--
-- Indices de la tabla `tbl_permisos_aplicacion_perfil`
--
ALTER TABLE `tbl_permisos_aplicacion_perfil`
  ADD PRIMARY KEY (`PK_id_Aplicacion_Perfil`),
  ADD KEY `Fk_id_aplicacion` (`Fk_id_aplicacion`),
  ADD KEY `Fk_id_perfil` (`Fk_id_perfil`);

--
-- Indices de la tabla `tbl_planilla_detalle`
--
ALTER TABLE `tbl_planilla_detalle`
  ADD PRIMARY KEY (`pk_registro_planilla_Detalle`),
  ADD KEY `fk_clave_empleado` (`fk_clave_empleado`),
  ADD KEY `fk_id_contrato` (`fk_id_contrato`),
  ADD KEY `fk_id_registro_planilla_Encabezado` (`fk_id_registro_planilla_Encabezado`);

--
-- Indices de la tabla `tbl_planilla_encabezado`
--
ALTER TABLE `tbl_planilla_encabezado`
  ADD PRIMARY KEY (`pk_registro_planilla_Encabezado`);

--
-- Indices de la tabla `tbl_poliza`
--
ALTER TABLE `tbl_poliza`
  ADD PRIMARY KEY (`Pk_id_poliza`);

--
-- Indices de la tabla `tbl_polizadetalle`
--
ALTER TABLE `tbl_polizadetalle`
  ADD PRIMARY KEY (`Pk_id_polizadetalle`),
  ADD KEY `Pk_id_polizaencabezado` (`Pk_id_polizaencabezado`),
  ADD KEY `Pk_id_cuenta` (`Pk_id_cuenta`),
  ADD KEY `Pk_id_tipooperacion` (`Pk_id_tipooperacion`);

--
-- Indices de la tabla `tbl_polizaencabezado`
--
ALTER TABLE `tbl_polizaencabezado`
  ADD PRIMARY KEY (`Pk_id_polizaencabezado`),
  ADD KEY `Pk_id_tipopoliza` (`Pk_id_tipopoliza`);

--
-- Indices de la tabla `tbl_poliza_contabilidad`
--
ALTER TABLE `tbl_poliza_contabilidad`
  ADD PRIMARY KEY (`Fk_id_poliza`,`Fk_id_contabilidad`),
  ADD KEY `Fk_id_contabilidad` (`Fk_id_contabilidad`);

--
-- Indices de la tabla `tbl_poliza_rango_fechas`
--
ALTER TABLE `tbl_poliza_rango_fechas`
  ADD PRIMARY KEY (`Fk_id_poliza`,`Fk_id_rango`),
  ADD KEY `Fk_id_rango` (`Fk_id_rango`);

--
-- Indices de la tabla `tbl_presupuesto`
--
ALTER TABLE `tbl_presupuesto`
  ADD PRIMARY KEY (`Pk_id_presupuesto`);

--
-- Indices de la tabla `tbl_proceso_produccion_detalle`
--
ALTER TABLE `tbl_proceso_produccion_detalle`
  ADD PRIMARY KEY (`Pk_id_proceso_detalle`),
  ADD KEY `idx_fk_productos` (`Fk_id_productos`),
  ADD KEY `idx_fk_receta` (`Fk_id_receta`),
  ADD KEY `idx_fk_empleado` (`Fk_id_empleado`),
  ADD KEY `idx_fk_proceso` (`Fk_id_proceso`);

--
-- Indices de la tabla `tbl_proceso_produccion_encabezado`
--
ALTER TABLE `tbl_proceso_produccion_encabezado`
  ADD PRIMARY KEY (`Pk_id_proceso`),
  ADD KEY `idx_fk_orden` (`Fk_id_orden`),
  ADD KEY `idx_fk_maquinaria` (`Fk_id_maquinaria`);

--
-- Indices de la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  ADD PRIMARY KEY (`Pk_id_Producto`),
  ADD UNIQUE KEY `UQ_codigoProducto` (`codigoProducto`),
  ADD KEY `idx_fk_receta_producto` (`Fk_id_receta`);

--
-- Indices de la tabla `tbl_proveedores`
--
ALTER TABLE `tbl_proveedores`
  ADD PRIMARY KEY (`Pk_prov_id`);

--
-- Indices de la tabla `tbl_puestos_trabajo`
--
ALTER TABLE `tbl_puestos_trabajo`
  ADD PRIMARY KEY (`pk_id_puestos`);

--
-- Indices de la tabla `tbl_rango_fechas`
--
ALTER TABLE `tbl_rango_fechas`
  ADD PRIMARY KEY (`Pk_id_rango`);

--
-- Indices de la tabla `tbl_recetas`
--
ALTER TABLE `tbl_recetas`
  ADD PRIMARY KEY (`Pk_id_receta`);

--
-- Indices de la tabla `tbl_receta_detalle`
--
ALTER TABLE `tbl_receta_detalle`
  ADD PRIMARY KEY (`Pk_id_detalle`),
  ADD KEY `idx_fk_receta` (`Fk_id_receta`),
  ADD KEY `idx_fk_producto` (`Fk_id_producto`);

--
-- Indices de la tabla `tbl_regreporteria`
--
ALTER TABLE `tbl_regreporteria`
  ADD PRIMARY KEY (`idregistro`),
  ADD KEY `Fk_id_modulos` (`Fk_id_modulos`),
  ADD KEY `Fk_id_aplicacion` (`Fk_id_aplicacion`);

--
-- Indices de la tabla `tbl_remitente`
--
ALTER TABLE `tbl_remitente`
  ADD PRIMARY KEY (`Pk_id_remitente`);

--
-- Indices de la tabla `tbl_rrhh_produccion`
--
ALTER TABLE `tbl_rrhh_produccion`
  ADD PRIMARY KEY (`pk_id_RRHH`);

--
-- Indices de la tabla `tbl_tipoactivofijo`
--
ALTER TABLE `tbl_tipoactivofijo`
  ADD PRIMARY KEY (`Pk_Id_TipoActivoFijo`);

--
-- Indices de la tabla `tbl_tipocambio`
--
ALTER TABLE `tbl_tipocambio`
  ADD PRIMARY KEY (`pk_id_tipoCambio`);

--
-- Indices de la tabla `tbl_tipocuenta`
--
ALTER TABLE `tbl_tipocuenta`
  ADD PRIMARY KEY (`PK_id_tipocuenta`);

--
-- Indices de la tabla `tbl_tipooperacion`
--
ALTER TABLE `tbl_tipooperacion`
  ADD PRIMARY KEY (`Pk_id_tipooperacion`);

--
-- Indices de la tabla `tbl_tipopoliza`
--
ALTER TABLE `tbl_tipopoliza`
  ADD PRIMARY KEY (`Pk_id_tipopoliza`);

--
-- Indices de la tabla `tbl_transaccion`
--
ALTER TABLE `tbl_transaccion`
  ADD PRIMARY KEY (`pk_transaccion_id`),
  ADD KEY `fk_cuenta_id` (`fk_cuenta_id`);

--
-- Indices de la tabla `tbl_transaccion_cliente`
--
ALTER TABLE `tbl_transaccion_cliente`
  ADD PRIMARY KEY (`Pk_id_transaccion`),
  ADD KEY `Fk_id_cliente` (`Fk_id_cliente`),
  ADD KEY `fk_factura_trans_cliente` (`Fk_id_factura`),
  ADD KEY `fk_transC_trans_cliente` (`Fk_id_transC`);

--
-- Indices de la tabla `tbl_transaccion_cuentas`
--
ALTER TABLE `tbl_transaccion_cuentas`
  ADD PRIMARY KEY (`Pk_id_tran_cue`);

--
-- Indices de la tabla `tbl_transaccion_proveedor`
--
ALTER TABLE `tbl_transaccion_proveedor`
  ADD PRIMARY KEY (`Pk_id_transaccion`),
  ADD KEY `Fk_id_proveedor` (`Fk_id_proveedor`),
  ADD KEY `fk_transC_trans_proveedor` (`Fk_id_transC`);

--
-- Indices de la tabla `tbl_trasladoproductos`
--
ALTER TABLE `tbl_trasladoproductos`
  ADD PRIMARY KEY (`Pk_id_TrasladoProductos`),
  ADD KEY `Fk_id_Producto` (`Fk_id_Producto`),
  ADD KEY `Fk_id_guia` (`Fk_id_guia`);

--
-- Indices de la tabla `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  ADD PRIMARY KEY (`Pk_id_usuario`);

--
-- Indices de la tabla `tbl_vehiculos`
--
ALTER TABLE `tbl_vehiculos`
  ADD PRIMARY KEY (`Pk_id_vehiculo`),
  ADD KEY `Fk_id_chofer` (`Fk_id_chofer`);

--
-- Indices de la tabla `tbl_vendedores`
--
ALTER TABLE `tbl_vendedores`
  ADD PRIMARY KEY (`Pk_id_vendedor`),
  ADD KEY `Fk_id_empleado` (`Fk_id_empleado`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id_venta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ayuda`
--
ALTER TABLE `ayuda`
  MODIFY `Id_ayuda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tbl_activofijo`
--
ALTER TABLE `tbl_activofijo`
  MODIFY `Pk_Id_ActivoFijo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_asignaciones_perfils_usuario`
--
ALTER TABLE `tbl_asignaciones_perfils_usuario`
  MODIFY `PK_id_Perfil_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tbl_asignacion_vacaciones`
--
ALTER TABLE `tbl_asignacion_vacaciones`
  MODIFY `pk_registro_vaciones` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_auditorias`
--
ALTER TABLE `tbl_auditorias`
  MODIFY `Pk_ID_AUDITORIA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_banco`
--
ALTER TABLE `tbl_banco`
  MODIFY `pk_banco_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_bitacora`
--
ALTER TABLE `tbl_bitacora`
  MODIFY `Pk_id_bitacora` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT de la tabla `tbl_bodegas`
--
ALTER TABLE `tbl_bodegas`
  MODIFY `Pk_ID_BODEGA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_caja_cliente`
--
ALTER TABLE `tbl_caja_cliente`
  MODIFY `Pk_id_caja_cliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_caja_proveedor`
--
ALTER TABLE `tbl_caja_proveedor`
  MODIFY `Pk_id_caja_proveedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_chofer`
--
ALTER TABLE `tbl_chofer`
  MODIFY `Pk_id_chofer` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_cierre_produccion`
--
ALTER TABLE `tbl_cierre_produccion`
  MODIFY `pk_id_cierre` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_clasificacionlista`
--
ALTER TABLE `tbl_clasificacionlista`
  MODIFY `pk_id_clasificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_cobrador`
--
ALTER TABLE `tbl_cobrador`
  MODIFY `Pk_id_cobrador` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_configuracion`
--
ALTER TABLE `tbl_configuracion`
  MODIFY `Pk_id_config` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_consultainteligente`
--
ALTER TABLE `tbl_consultainteligente`
  MODIFY `Pk_consultaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tbl_contratos`
--
ALTER TABLE `tbl_contratos`
  MODIFY `pk_id_contrato` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_control_anticipos`
--
ALTER TABLE `tbl_control_anticipos`
  MODIFY `pk_registro_anticipos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_control_faltas`
--
ALTER TABLE `tbl_control_faltas`
  MODIFY `pk_registro_faltas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_conversiones`
--
ALTER TABLE `tbl_conversiones`
  MODIFY `id_conversion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_cuentabancaria`
--
ALTER TABLE `tbl_cuentabancaria`
  MODIFY `pk_cuenta_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_datos_pedido`
--
ALTER TABLE `tbl_datos_pedido`
  MODIFY `Pk_id_guia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_dedu_perp`
--
ALTER TABLE `tbl_dedu_perp`
  MODIFY `pk_dedu_perp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tbl_dedu_perp_emp`
--
ALTER TABLE `tbl_dedu_perp_emp`
  MODIFY `pk_dedu_perp_emp` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_departamentos`
--
ALTER TABLE `tbl_departamentos`
  MODIFY `pk_id_departamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_depreciacion_activofijo`
--
ALTER TABLE `tbl_depreciacion_activofijo`
  MODIFY `Pk_Id_Depreciacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_destinatario`
--
ALTER TABLE `tbl_destinatario`
  MODIFY `Pk_id_destinatario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_detalle_presupuesto`
--
ALTER TABLE `tbl_detalle_presupuesto`
  MODIFY `Pk_id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_deudas_clientes`
--
ALTER TABLE `tbl_deudas_clientes`
  MODIFY `Pk_id_deuda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_deudas_proveedores`
--
ALTER TABLE `tbl_deudas_proveedores`
  MODIFY `Pk_id_deuda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_empleados`
--
ALTER TABLE `tbl_empleados`
  MODIFY `pk_clave` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_empresas`
--
ALTER TABLE `tbl_empresas`
  MODIFY `empresa_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_existencias_bodega`
--
ALTER TABLE `tbl_existencias_bodega`
  MODIFY `Pk_ID_EXISTENCIA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_explosion`
--
ALTER TABLE `tbl_explosion`
  MODIFY `pk_id_explosion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_historial_servicio`
--
ALTER TABLE `tbl_historial_servicio`
  MODIFY `Pk_Id_HistorialServicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_horas_extra`
--
ALTER TABLE `tbl_horas_extra`
  MODIFY `pk_registro_horas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_identidadactivo`
--
ALTER TABLE `tbl_identidadactivo`
  MODIFY `Pk_Id_Identidad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_implosion`
--
ALTER TABLE `tbl_implosion`
  MODIFY `pk_id_implosion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_linea`
--
ALTER TABLE `tbl_linea`
  MODIFY `Pk_id_linea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_liquidacion_trabajadores`
--
ALTER TABLE `tbl_liquidacion_trabajadores`
  MODIFY `pk_registro_liquidacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_locales`
--
ALTER TABLE `tbl_locales`
  MODIFY `Pk_ID_LOCAL` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_lotes_detalles`
--
ALTER TABLE `tbl_lotes_detalles`
  MODIFY `Pk_id_lotes_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_lotes_encabezado`
--
ALTER TABLE `tbl_lotes_encabezado`
  MODIFY `Pk_id_lote` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  MODIFY `Pk_id_Mantenimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_mantenimientos`
--
ALTER TABLE `tbl_mantenimientos`
  MODIFY `Pk_id_maquinaria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_maquinaria`
--
ALTER TABLE `tbl_maquinaria`
  MODIFY `pk_id_maquina` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_marca`
--
ALTER TABLE `tbl_marca`
  MODIFY `Pk_id_Marca` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_mora_clientes`
--
ALTER TABLE `tbl_mora_clientes`
  MODIFY `Pk_id_mora` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_movimientobancario`
--
ALTER TABLE `tbl_movimientobancario`
  MODIFY `pk_movimientobancario_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_movimiento_de_inventario`
--
ALTER TABLE `tbl_movimiento_de_inventario`
  MODIFY `Pk_id_movimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_ordenes_produccion`
--
ALTER TABLE `tbl_ordenes_produccion`
  MODIFY `Pk_id_orden` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_ordenes_produccion_detalle`
--
ALTER TABLE `tbl_ordenes_produccion_detalle`
  MODIFY `Pk_id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_perfiles`
--
ALTER TABLE `tbl_perfiles`
  MODIFY `Pk_id_perfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tbl_permisos_aplicaciones_usuario`
--
ALTER TABLE `tbl_permisos_aplicaciones_usuario`
  MODIFY `PK_id_Aplicacion_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tbl_permisos_aplicacion_perfil`
--
ALTER TABLE `tbl_permisos_aplicacion_perfil`
  MODIFY `PK_id_Aplicacion_Perfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=223;

--
-- AUTO_INCREMENT de la tabla `tbl_planilla_detalle`
--
ALTER TABLE `tbl_planilla_detalle`
  MODIFY `pk_registro_planilla_Detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_planilla_encabezado`
--
ALTER TABLE `tbl_planilla_encabezado`
  MODIFY `pk_registro_planilla_Encabezado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_polizadetalle`
--
ALTER TABLE `tbl_polizadetalle`
  MODIFY `Pk_id_polizadetalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_polizaencabezado`
--
ALTER TABLE `tbl_polizaencabezado`
  MODIFY `Pk_id_polizaencabezado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_presupuesto`
--
ALTER TABLE `tbl_presupuesto`
  MODIFY `Pk_id_presupuesto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_proceso_produccion_detalle`
--
ALTER TABLE `tbl_proceso_produccion_detalle`
  MODIFY `Pk_id_proceso_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_proceso_produccion_encabezado`
--
ALTER TABLE `tbl_proceso_produccion_encabezado`
  MODIFY `Pk_id_proceso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  MODIFY `Pk_id_Producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tbl_puestos_trabajo`
--
ALTER TABLE `tbl_puestos_trabajo`
  MODIFY `pk_id_puestos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tbl_recetas`
--
ALTER TABLE `tbl_recetas`
  MODIFY `Pk_id_receta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_receta_detalle`
--
ALTER TABLE `tbl_receta_detalle`
  MODIFY `Pk_id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_regreporteria`
--
ALTER TABLE `tbl_regreporteria`
  MODIFY `idregistro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tbl_remitente`
--
ALTER TABLE `tbl_remitente`
  MODIFY `Pk_id_remitente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_rrhh_produccion`
--
ALTER TABLE `tbl_rrhh_produccion`
  MODIFY `pk_id_RRHH` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_tipoactivofijo`
--
ALTER TABLE `tbl_tipoactivofijo`
  MODIFY `Pk_Id_TipoActivoFijo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_tipocambio`
--
ALTER TABLE `tbl_tipocambio`
  MODIFY `pk_id_tipoCambio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_transaccion`
--
ALTER TABLE `tbl_transaccion`
  MODIFY `pk_transaccion_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_transaccion_cliente`
--
ALTER TABLE `tbl_transaccion_cliente`
  MODIFY `Pk_id_transaccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `tbl_transaccion_cuentas`
--
ALTER TABLE `tbl_transaccion_cuentas`
  MODIFY `Pk_id_tran_cue` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tbl_transaccion_proveedor`
--
ALTER TABLE `tbl_transaccion_proveedor`
  MODIFY `Pk_id_transaccion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_trasladoproductos`
--
ALTER TABLE `tbl_trasladoproductos`
  MODIFY `Pk_id_TrasladoProductos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  MODIFY `Pk_id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbl_vehiculos`
--
ALTER TABLE `tbl_vehiculos`
  MODIFY `Pk_id_vehiculo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_activofijo`
--
ALTER TABLE `tbl_activofijo`
  ADD CONSTRAINT `Fk_Cuenta_New` FOREIGN KEY (`Pk_Id_Cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`) ON DELETE CASCADE,
  ADD CONSTRAINT `Fk_Identidad_New` FOREIGN KEY (`Pk_Id_Identidad`) REFERENCES `tbl_identidadactivo` (`Pk_Id_Identidad`) ON DELETE SET NULL,
  ADD CONSTRAINT `Fk_TipoActivoFijo_New` FOREIGN KEY (`Pk_Id_TipoActivoFijo`) REFERENCES `tbl_tipoactivofijo` (`Pk_Id_TipoActivoFijo`) ON DELETE SET NULL;

--
-- Filtros para la tabla `tbl_asignaciones_perfils_usuario`
--
ALTER TABLE `tbl_asignaciones_perfils_usuario`
  ADD CONSTRAINT `tbl_asignaciones_perfils_usuario_ibfk_1` FOREIGN KEY (`Fk_id_usuario`) REFERENCES `tbl_usuarios` (`Pk_id_usuario`),
  ADD CONSTRAINT `tbl_asignaciones_perfils_usuario_ibfk_2` FOREIGN KEY (`Fk_id_perfil`) REFERENCES `tbl_perfiles` (`Pk_id_perfil`);

--
-- Filtros para la tabla `tbl_asignacion_modulo_aplicacion`
--
ALTER TABLE `tbl_asignacion_modulo_aplicacion`
  ADD CONSTRAINT `tbl_asignacion_modulo_aplicacion_ibfk_1` FOREIGN KEY (`Fk_id_modulos`) REFERENCES `tbl_modulos` (`Pk_id_modulos`),
  ADD CONSTRAINT `tbl_asignacion_modulo_aplicacion_ibfk_2` FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `tbl_aplicaciones` (`Pk_id_aplicacion`);

--
-- Filtros para la tabla `tbl_asignacion_vacaciones`
--
ALTER TABLE `tbl_asignacion_vacaciones`
  ADD CONSTRAINT `tbl_asignacion_vacaciones_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_auditorias`
--
ALTER TABLE `tbl_auditorias`
  ADD CONSTRAINT `tbl_auditorias_ibfk_1` FOREIGN KEY (`Fk_ID_BODEGA`) REFERENCES `tbl_bodegas` (`Pk_ID_BODEGA`),
  ADD CONSTRAINT `tbl_auditorias_ibfk_2` FOREIGN KEY (`Fk_ID_PRODUCTO`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_bitacora`
--
ALTER TABLE `tbl_bitacora`
  ADD CONSTRAINT `tbl_bitacora_ibfk_1` FOREIGN KEY (`Fk_id_usuario`) REFERENCES `tbl_usuarios` (`Pk_id_usuario`),
  ADD CONSTRAINT `tbl_bitacora_ibfk_2` FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `tbl_aplicaciones` (`Pk_id_aplicacion`);

--
-- Filtros para la tabla `tbl_caja_cliente`
--
ALTER TABLE `tbl_caja_cliente`
  ADD CONSTRAINT `id_factura` FOREIGN KEY (`Fk_id_factura`) REFERENCES `tbl_factura` (`Pk_id_factura`),
  ADD CONSTRAINT `tbl_caja_cliente_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`),
  ADD CONSTRAINT `tbl_caja_cliente_ibfk_2` FOREIGN KEY (`Fk_id_deuda`) REFERENCES `tbl_deudas_clientes` (`Pk_id_deuda`);

--
-- Filtros para la tabla `tbl_caja_proveedor`
--
ALTER TABLE `tbl_caja_proveedor`
  ADD CONSTRAINT `fk_factura_caja` FOREIGN KEY (`Fk_id_factura`) REFERENCES `tbl_factura` (`Pk_id_factura`),
  ADD CONSTRAINT `tbl_caja_proveedor_ibfk_1` FOREIGN KEY (`Fk_id_proveedor`) REFERENCES `tbl_proveedores` (`Pk_prov_id`),
  ADD CONSTRAINT `tbl_caja_proveedor_ibfk_2` FOREIGN KEY (`Fk_id_deuda`) REFERENCES `tbl_deudas_proveedores` (`Pk_id_deuda`);

--
-- Filtros para la tabla `tbl_cobrador`
--
ALTER TABLE `tbl_cobrador`
  ADD CONSTRAINT `tbl_cobrador_ibfk_1` FOREIGN KEY (`Fk_id_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_comisiones_encabezado`
--
ALTER TABLE `tbl_comisiones_encabezado`
  ADD CONSTRAINT `tbl_comisiones_encabezado_ibfk_1` FOREIGN KEY (`Fk_id_vendedor`) REFERENCES `tbl_vendedores` (`Pk_id_vendedor`);

--
-- Filtros para la tabla `tbl_configuracion`
--
ALTER TABLE `tbl_configuracion`
  ADD CONSTRAINT `tbl_configuracion_ibfk_1` FOREIGN KEY (`Pk_id_cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`);

--
-- Filtros para la tabla `tbl_contratos`
--
ALTER TABLE `tbl_contratos`
  ADD CONSTRAINT `tbl_contratos_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_control_anticipos`
--
ALTER TABLE `tbl_control_anticipos`
  ADD CONSTRAINT `tbl_control_anticipos_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_control_faltas`
--
ALTER TABLE `tbl_control_faltas`
  ADD CONSTRAINT `tbl_control_faltas_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_cotizacion_detalle`
--
ALTER TABLE `tbl_cotizacion_detalle`
  ADD CONSTRAINT `tbl_cotizacion_detalle_ibfk_1` FOREIGN KEY (`Fk_id_cotizacionEnc`) REFERENCES `tbl_cotizacion_encabezado` (`Pk_id_cotizacionEnc`),
  ADD CONSTRAINT `tbl_cotizacion_detalle_ibfk_2` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_cotizacion_encabezado`
--
ALTER TABLE `tbl_cotizacion_encabezado`
  ADD CONSTRAINT `tbl_cotizacion_encabezado_ibfk_1` FOREIGN KEY (`Fk_id_vendedor`) REFERENCES `tbl_vendedores` (`Pk_id_vendedor`),
  ADD CONSTRAINT `tbl_cotizacion_encabezado_ibfk_2` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`);

--
-- Filtros para la tabla `tbl_cuentabancaria`
--
ALTER TABLE `tbl_cuentabancaria`
  ADD CONSTRAINT `fk_banco` FOREIGN KEY (`fk_banco_id`) REFERENCES `tbl_banco` (`pk_banco_id`);

--
-- Filtros para la tabla `tbl_cuentas`
--
ALTER TABLE `tbl_cuentas`
  ADD CONSTRAINT `tbl_cuentas_ibfk_1` FOREIGN KEY (`Pk_id_tipocuenta`) REFERENCES `tbl_tipocuenta` (`PK_id_tipocuenta`),
  ADD CONSTRAINT `tbl_cuentas_ibfk_2` FOREIGN KEY (`Pk_id_encabezadocuenta`) REFERENCES `tbl_encabezadoclasecuenta` (`Pk_id_encabezadocuenta`),
  ADD CONSTRAINT `tbl_cuentas_ibfk_3` FOREIGN KEY (`Pk_id_cuenta_enlace`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`);

--
-- Filtros para la tabla `tbl_datos_pedido`
--
ALTER TABLE `tbl_datos_pedido`
  ADD CONSTRAINT `tbl_datos_pedido_ibfk_1` FOREIGN KEY (`Fk_id_remitente`) REFERENCES `tbl_remitente` (`Pk_id_remitente`),
  ADD CONSTRAINT `tbl_datos_pedido_ibfk_2` FOREIGN KEY (`Fk_id_destinatario`) REFERENCES `tbl_destinatario` (`Pk_id_destinatario`),
  ADD CONSTRAINT `tbl_datos_pedido_ibfk_3` FOREIGN KEY (`Fk_id_vehiculo`) REFERENCES `tbl_vehiculos` (`Pk_id_vehiculo`);

--
-- Filtros para la tabla `tbl_dedu_perp_emp`
--
ALTER TABLE `tbl_dedu_perp_emp`
  ADD CONSTRAINT `tbl_dedu_perp_emp_ibfk_1` FOREIGN KEY (`Fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`),
  ADD CONSTRAINT `tbl_dedu_perp_emp_ibfk_2` FOREIGN KEY (`Fk_dedu_perp`) REFERENCES `tbl_dedu_perp` (`pk_dedu_perp`);

--
-- Filtros para la tabla `tbl_depreciacion_activofijo`
--
ALTER TABLE `tbl_depreciacion_activofijo`
  ADD CONSTRAINT `Fk_Cuenta_Depreciacion_New` FOREIGN KEY (`Pk_Id_Cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`) ON DELETE CASCADE,
  ADD CONSTRAINT `Fk_IdActivoFijo_Depreciacion` FOREIGN KEY (`Pk_Id_ActivoFijo`) REFERENCES `tbl_activofijo` (`Pk_Id_ActivoFijo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tbl_detalleordenescompra`
--
ALTER TABLE `tbl_detalleordenescompra`
  ADD CONSTRAINT `tbl_detalleordenescompra_ibfk_1` FOREIGN KEY (`FK_encOrCom_numeroOC`) REFERENCES `tbl_encabezadoordencompra` (`PK_encOrCom_numeroOC`),
  ADD CONSTRAINT `tbl_detalleordenescompra_ibfk_2` FOREIGN KEY (`FK_codigoProducto`) REFERENCES `tbl_productos` (`codigoProducto`);

--
-- Filtros para la tabla `tbl_detalle_comisiones`
--
ALTER TABLE `tbl_detalle_comisiones`
  ADD CONSTRAINT `tbl_detalle_comisiones_ibfk_1` FOREIGN KEY (`Fk_id_comisionEnc`) REFERENCES `tbl_comisiones_encabezado` (`Pk_id_comisionEnc`),
  ADD CONSTRAINT `tbl_detalle_comisiones_ibfk_2` FOREIGN KEY (`Fk_id_facturaEnc`) REFERENCES `tbl_factura_encabezado` (`Pk_id_facturaEnc`);

--
-- Filtros para la tabla `tbl_detalle_presupuesto`
--
ALTER TABLE `tbl_detalle_presupuesto`
  ADD CONSTRAINT `tbl_detalle_presupuesto_ibfk_1` FOREIGN KEY (`Fk_id_presupuesto`) REFERENCES `tbl_presupuesto` (`Pk_id_presupuesto`),
  ADD CONSTRAINT `tbl_detalle_presupuesto_ibfk_2` FOREIGN KEY (`Fk_id_cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`);

--
-- Filtros para la tabla `tbl_deudas_clientes`
--
ALTER TABLE `tbl_deudas_clientes`
  ADD CONSTRAINT `fk_id_factura` FOREIGN KEY (`Fk_id_factura`) REFERENCES `tbl_factura` (`Pk_id_factura`),
  ADD CONSTRAINT `tbl_deudas_clientes_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`),
  ADD CONSTRAINT `tbl_deudas_clientes_ibfk_2` FOREIGN KEY (`Fk_id_cobrador`) REFERENCES `tbl_cobrador` (`Pk_id_cobrador`);

--
-- Filtros para la tabla `tbl_deudas_proveedores`
--
ALTER TABLE `tbl_deudas_proveedores`
  ADD CONSTRAINT `fk_id_factura2` FOREIGN KEY (`Fk_id_factura`) REFERENCES `tbl_factura` (`Pk_id_factura`),
  ADD CONSTRAINT `tbl_deudas_proveedores_ibfk_1` FOREIGN KEY (`Fk_id_proveedor`) REFERENCES `tbl_proveedores` (`Pk_prov_id`);

--
-- Filtros para la tabla `tbl_empleados`
--
ALTER TABLE `tbl_empleados`
  ADD CONSTRAINT `tbl_empleados_ibfk_1` FOREIGN KEY (`fk_id_departamento`) REFERENCES `tbl_departamentos` (`pk_id_departamento`),
  ADD CONSTRAINT `tbl_empleados_ibfk_2` FOREIGN KEY (`fk_id_puestos`) REFERENCES `tbl_puestos_trabajo` (`pk_id_puestos`);

--
-- Filtros para la tabla `tbl_encabezadoordencompra`
--
ALTER TABLE `tbl_encabezadoordencompra`
  ADD CONSTRAINT `tbl_encabezadoordencompra_ibfk_1` FOREIGN KEY (`Fk_prov_id`) REFERENCES `tbl_proveedores` (`Pk_prov_id`);

--
-- Filtros para la tabla `tbl_existencias_bodega`
--
ALTER TABLE `tbl_existencias_bodega`
  ADD CONSTRAINT `FK_EXISTENCIA_BODEGA` FOREIGN KEY (`Fk_ID_BODEGA`) REFERENCES `tbl_bodegas` (`Pk_ID_BODEGA`),
  ADD CONSTRAINT `FK_EXISTENCIA_PRODUCTO` FOREIGN KEY (`Fk_ID_PRODUCTO`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_explosion`
--
ALTER TABLE `tbl_explosion`
  ADD CONSTRAINT `tbl_explosion_ibfk_1` FOREIGN KEY (`fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `tbl_explosion_ibfk_2` FOREIGN KEY (`fk_id_proceso`) REFERENCES `tbl_proceso_produccion_encabezado` (`Pk_id_proceso`);

--
-- Filtros para la tabla `tbl_factura`
--
ALTER TABLE `tbl_factura`
  ADD CONSTRAINT `tbl_factura_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`),
  ADD CONSTRAINT `tbl_factura_ibfk_2` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`);

--
-- Filtros para la tabla `tbl_factura_detalle`
--
ALTER TABLE `tbl_factura_detalle`
  ADD CONSTRAINT `tbl_factura_detalle_ibfk_1` FOREIGN KEY (`fk_id_facturaEnc`) REFERENCES `tbl_factura_encabezado` (`Pk_id_facturaEnc`),
  ADD CONSTRAINT `tbl_factura_detalle_ibfk_2` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_factura_encabezado`
--
ALTER TABLE `tbl_factura_encabezado`
  ADD CONSTRAINT `tbl_factura_encabezado_ibfk_1` FOREIGN KEY (`Fk_id_vendedor`) REFERENCES `tbl_vendedores` (`Pk_id_vendedor`),
  ADD CONSTRAINT `tbl_factura_encabezado_ibfk_2` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`);

--
-- Filtros para la tabla `tbl_historial_servicio`
--
ALTER TABLE `tbl_historial_servicio`
  ADD CONSTRAINT `Fk_ActivoFijo_HistorialServicio` FOREIGN KEY (`Pk_Id_ActivoFijo`) REFERENCES `tbl_activofijo` (`Pk_Id_ActivoFijo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tbl_historico_cuentas`
--
ALTER TABLE `tbl_historico_cuentas`
  ADD CONSTRAINT `tbl_historico_cuentas_ibfk_1` FOREIGN KEY (`Pk_id_cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`);

--
-- Filtros para la tabla `tbl_horas_extra`
--
ALTER TABLE `tbl_horas_extra`
  ADD CONSTRAINT `tbl_horas_extra_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_linea`
--
ALTER TABLE `tbl_linea`
  ADD CONSTRAINT `tbl_linea_ibfk_1` FOREIGN KEY (`fk_id_marca`) REFERENCES `tbl_marca` (`Pk_id_Marca`);

--
-- Filtros para la tabla `tbl_liquidacion_trabajadores`
--
ALTER TABLE `tbl_liquidacion_trabajadores`
  ADD CONSTRAINT `tbl_liquidacion_trabajadores_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);

--
-- Filtros para la tabla `tbl_lista_detalle`
--
ALTER TABLE `tbl_lista_detalle`
  ADD CONSTRAINT `fk_lista_encabezado` FOREIGN KEY (`Fk_id_lista_Encabezado`) REFERENCES `tbl_lista_encabezado` (`Pk_id_lista_Encabezado`),
  ADD CONSTRAINT `fk_producto` FOREIGN KEY (`Fk_id_Producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `tbl_lista_detalle_ibfk_1` FOREIGN KEY (`Fk_id_lista_Encabezado`) REFERENCES `tbl_lista_encabezado` (`Pk_id_lista_Encabezado`),
  ADD CONSTRAINT `tbl_lista_detalle_ibfk_2` FOREIGN KEY (`Fk_id_Producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_lista_encabezado`
--
ALTER TABLE `tbl_lista_encabezado`
  ADD CONSTRAINT `fk_clasificacion` FOREIGN KEY (`Fk_id_clasificacion`) REFERENCES `tbl_clasificacionlista` (`pk_id_clasificacion`);

--
-- Filtros para la tabla `tbl_lotes_detalles`
--
ALTER TABLE `tbl_lotes_detalles`
  ADD CONSTRAINT `fk_lote_lotes_detalles` FOREIGN KEY (`Fk_id_lote`) REFERENCES `tbl_lotes_encabezado` (`Pk_id_lote`),
  ADD CONSTRAINT `fk_producto_lotes_detalles` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_lotes_encabezado`
--
ALTER TABLE `tbl_lotes_encabezado`
  ADD CONSTRAINT `fk_proceso_lote_encabezado` FOREIGN KEY (`Fk_id_proceso`) REFERENCES `tbl_proceso_produccion_encabezado` (`Pk_id_proceso`);

--
-- Filtros para la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD CONSTRAINT `tbl_mantenimiento_ibfk_1` FOREIGN KEY (`Fk_id_vehiculo`) REFERENCES `tbl_vehiculos` (`Pk_id_vehiculo`);

--
-- Filtros para la tabla `tbl_mantenimientos`
--
ALTER TABLE `tbl_mantenimientos`
  ADD CONSTRAINT `fk_maquina` FOREIGN KEY (`fk_id_maquina`) REFERENCES `tbl_maquinaria` (`pk_id_maquina`);

--
-- Filtros para la tabla `tbl_marca`
--
ALTER TABLE `tbl_marca`
  ADD CONSTRAINT `tbl_marca_ibfk_1` FOREIGN KEY (`fk_id_Producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_mora_clientes`
--
ALTER TABLE `tbl_mora_clientes`
  ADD CONSTRAINT `tbl_mora_clientes_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`),
  ADD CONSTRAINT `tbl_mora_clientes_ibfk_2` FOREIGN KEY (`Fk_id_transaccion`) REFERENCES `tbl_transaccion_cliente` (`Pk_id_transaccion`);

--
-- Filtros para la tabla `tbl_movimiento`
--
ALTER TABLE `tbl_movimiento`
  ADD CONSTRAINT `tbl_movimiento_ibfk_1` FOREIGN KEY (`Fk_id_poliza`) REFERENCES `tbl_poliza` (`Pk_id_poliza`);

--
-- Filtros para la tabla `tbl_movimientobancario`
--
ALTER TABLE `tbl_movimientobancario`
  ADD CONSTRAINT `fk_cuenta` FOREIGN KEY (`fk_cuenta_id`) REFERENCES `tbl_cuentabancaria` (`pk_cuenta_id`);

--
-- Filtros para la tabla `tbl_movimiento_de_inventario`
--
ALTER TABLE `tbl_movimiento_de_inventario`
  ADD CONSTRAINT `FK_EXISTENCIA_LOCAL` FOREIGN KEY (`Fk_ID_LOCALES`) REFERENCES `tbl_locales` (`Pk_ID_LOCAL`),
  ADD CONSTRAINT `tbl_movimiento_de_inventario_ibfk_1` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `tbl_movimiento_de_inventario_ibfk_2` FOREIGN KEY (`Fk_id_stock`) REFERENCES `tbl_trasladoproductos` (`Pk_id_TrasladoProductos`);

--
-- Filtros para la tabla `tbl_ordenes_produccion_detalle`
--
ALTER TABLE `tbl_ordenes_produccion_detalle`
  ADD CONSTRAINT `fk_orden_detalle_produccion` FOREIGN KEY (`Fk_id_orden`) REFERENCES `tbl_ordenes_produccion` (`Pk_id_orden`),
  ADD CONSTRAINT `fk_producto_detalle_produccion` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`);

--
-- Filtros para la tabla `tbl_pedido_detalle`
--
ALTER TABLE `tbl_pedido_detalle`
  ADD CONSTRAINT `tbl_pedido_detalle_ibfk_1` FOREIGN KEY (`Fk_id_pedidoEnc`) REFERENCES `tbl_pedido_encabezado` (`Pk_id_pedidoEnc`),
  ADD CONSTRAINT `tbl_pedido_detalle_ibfk_2` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `tbl_pedido_detalle_ibfk_3` FOREIGN KEY (`Fk_id_cotizacionEnc`) REFERENCES `tbl_cotizacion_encabezado` (`Pk_id_cotizacionEnc`);

--
-- Filtros para la tabla `tbl_pedido_encabezado`
--
ALTER TABLE `tbl_pedido_encabezado`
  ADD CONSTRAINT `tbl_pedido_encabezado_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`),
  ADD CONSTRAINT `tbl_pedido_encabezado_ibfk_2` FOREIGN KEY (`Fk_id_vendedor`) REFERENCES `tbl_vendedores` (`Pk_id_vendedor`);

--
-- Filtros para la tabla `tbl_permisos_aplicaciones_usuario`
--
ALTER TABLE `tbl_permisos_aplicaciones_usuario`
  ADD CONSTRAINT `tbl_permisos_aplicaciones_usuario_ibfk_1` FOREIGN KEY (`Fk_id_usuario`) REFERENCES `tbl_usuarios` (`Pk_id_usuario`),
  ADD CONSTRAINT `tbl_permisos_aplicaciones_usuario_ibfk_2` FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `tbl_aplicaciones` (`Pk_id_aplicacion`);

--
-- Filtros para la tabla `tbl_permisos_aplicacion_perfil`
--
ALTER TABLE `tbl_permisos_aplicacion_perfil`
  ADD CONSTRAINT `tbl_permisos_aplicacion_perfil_ibfk_1` FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `tbl_aplicaciones` (`Pk_id_aplicacion`),
  ADD CONSTRAINT `tbl_permisos_aplicacion_perfil_ibfk_2` FOREIGN KEY (`Fk_id_perfil`) REFERENCES `tbl_perfiles` (`Pk_id_perfil`);

--
-- Filtros para la tabla `tbl_planilla_detalle`
--
ALTER TABLE `tbl_planilla_detalle`
  ADD CONSTRAINT `tbl_planilla_detalle_ibfk_1` FOREIGN KEY (`fk_clave_empleado`) REFERENCES `tbl_empleados` (`pk_clave`),
  ADD CONSTRAINT `tbl_planilla_detalle_ibfk_2` FOREIGN KEY (`fk_id_contrato`) REFERENCES `tbl_contratos` (`pk_id_contrato`),
  ADD CONSTRAINT `tbl_planilla_detalle_ibfk_3` FOREIGN KEY (`fk_id_registro_planilla_Encabezado`) REFERENCES `tbl_planilla_encabezado` (`pk_registro_planilla_Encabezado`);

--
-- Filtros para la tabla `tbl_polizadetalle`
--
ALTER TABLE `tbl_polizadetalle`
  ADD CONSTRAINT `tbl_polizadetalle_ibfk_1` FOREIGN KEY (`Pk_id_polizaencabezado`) REFERENCES `tbl_polizaencabezado` (`Pk_id_polizaencabezado`),
  ADD CONSTRAINT `tbl_polizadetalle_ibfk_2` FOREIGN KEY (`Pk_id_cuenta`) REFERENCES `tbl_cuentas` (`Pk_id_cuenta`),
  ADD CONSTRAINT `tbl_polizadetalle_ibfk_3` FOREIGN KEY (`Pk_id_tipooperacion`) REFERENCES `tbl_tipooperacion` (`Pk_id_tipooperacion`);

--
-- Filtros para la tabla `tbl_polizaencabezado`
--
ALTER TABLE `tbl_polizaencabezado`
  ADD CONSTRAINT `tbl_polizaencabezado_ibfk_1` FOREIGN KEY (`Pk_id_tipopoliza`) REFERENCES `tbl_tipopoliza` (`Pk_id_tipopoliza`);

--
-- Filtros para la tabla `tbl_poliza_contabilidad`
--
ALTER TABLE `tbl_poliza_contabilidad`
  ADD CONSTRAINT `tbl_poliza_contabilidad_ibfk_1` FOREIGN KEY (`Fk_id_poliza`) REFERENCES `tbl_poliza` (`Pk_id_poliza`),
  ADD CONSTRAINT `tbl_poliza_contabilidad_ibfk_2` FOREIGN KEY (`Fk_id_contabilidad`) REFERENCES `tbl_contabilidad` (`Pk_id_contabilidad`);

--
-- Filtros para la tabla `tbl_poliza_rango_fechas`
--
ALTER TABLE `tbl_poliza_rango_fechas`
  ADD CONSTRAINT `tbl_poliza_rango_fechas_ibfk_1` FOREIGN KEY (`Fk_id_poliza`) REFERENCES `tbl_poliza` (`Pk_id_poliza`),
  ADD CONSTRAINT `tbl_poliza_rango_fechas_ibfk_2` FOREIGN KEY (`Fk_id_rango`) REFERENCES `tbl_rango_fechas` (`Pk_id_rango`);

--
-- Filtros para la tabla `tbl_proceso_produccion_detalle`
--
ALTER TABLE `tbl_proceso_produccion_detalle`
  ADD CONSTRAINT `fk_empleado_proceso_produccion` FOREIGN KEY (`Fk_id_empleado`) REFERENCES `tbl_empleados` (`pk_clave`),
  ADD CONSTRAINT `fk_proceso_produccion` FOREIGN KEY (`Fk_id_proceso`) REFERENCES `tbl_proceso_produccion_encabezado` (`Pk_id_proceso`),
  ADD CONSTRAINT `fk_productos_proceso_produccion` FOREIGN KEY (`Fk_id_productos`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `fk_receta_proceso_produccion` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`);

--
-- Filtros para la tabla `tbl_proceso_produccion_encabezado`
--
ALTER TABLE `tbl_proceso_produccion_encabezado`
  ADD CONSTRAINT `fk_maquinaria_proceso_produccion` FOREIGN KEY (`Fk_id_maquinaria`) REFERENCES `tbl_mantenimientos` (`Pk_id_maquinaria`),
  ADD CONSTRAINT `fk_orden_proceso_produccion` FOREIGN KEY (`Fk_id_orden`) REFERENCES `tbl_ordenes_produccion` (`Pk_id_orden`);

--
-- Filtros para la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  ADD CONSTRAINT `fk_receta_producto` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`);

--
-- Filtros para la tabla `tbl_receta_detalle`
--
ALTER TABLE `tbl_receta_detalle`
  ADD CONSTRAINT `fk_producto_receta_detalle` FOREIGN KEY (`Fk_id_producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `fk_receta_detalle` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`);

--
-- Filtros para la tabla `tbl_regreporteria`
--
ALTER TABLE `tbl_regreporteria`
  ADD CONSTRAINT `tbl_regreporteria_ibfk_1` FOREIGN KEY (`Fk_id_modulos`) REFERENCES `tbl_modulos` (`Pk_id_modulos`),
  ADD CONSTRAINT `tbl_regreporteria_ibfk_2` FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `tbl_aplicaciones` (`Pk_id_aplicacion`);

--
-- Filtros para la tabla `tbl_transaccion`
--
ALTER TABLE `tbl_transaccion`
  ADD CONSTRAINT `fk_cuenta_id` FOREIGN KEY (`fk_cuenta_id`) REFERENCES `tbl_cuentabancaria` (`pk_cuenta_id`);

--
-- Filtros para la tabla `tbl_transaccion_cliente`
--
ALTER TABLE `tbl_transaccion_cliente`
  ADD CONSTRAINT `fk_factura_trans_cliente` FOREIGN KEY (`Fk_id_factura`) REFERENCES `tbl_factura` (`Pk_id_factura`),
  ADD CONSTRAINT `fk_transC_trans_cliente` FOREIGN KEY (`Fk_id_transC`) REFERENCES `tbl_transaccion_cuentas` (`Pk_id_tran_cue`),
  ADD CONSTRAINT `tbl_transaccion_cliente_ibfk_1` FOREIGN KEY (`Fk_id_cliente`) REFERENCES `tbl_clientes` (`Pk_id_cliente`);

--
-- Filtros para la tabla `tbl_transaccion_proveedor`
--
ALTER TABLE `tbl_transaccion_proveedor`
  ADD CONSTRAINT `fk_transC_trans_proveedor` FOREIGN KEY (`Fk_id_transC`) REFERENCES `tbl_transaccion_cuentas` (`Pk_id_tran_cue`),
  ADD CONSTRAINT `tbl_transaccion_proveedor_ibfk_1` FOREIGN KEY (`Fk_id_proveedor`) REFERENCES `tbl_proveedores` (`Pk_prov_id`);

--
-- Filtros para la tabla `tbl_trasladoproductos`
--
ALTER TABLE `tbl_trasladoproductos`
  ADD CONSTRAINT `tbl_trasladoproductos_ibfk_1` FOREIGN KEY (`Fk_id_Producto`) REFERENCES `tbl_productos` (`Pk_id_Producto`),
  ADD CONSTRAINT `tbl_trasladoproductos_ibfk_2` FOREIGN KEY (`Fk_id_guia`) REFERENCES `tbl_datos_pedido` (`Pk_id_guia`);

--
-- Filtros para la tabla `tbl_vehiculos`
--
ALTER TABLE `tbl_vehiculos`
  ADD CONSTRAINT `tbl_vehiculos_ibfk_1` FOREIGN KEY (`Fk_id_chofer`) REFERENCES `tbl_chofer` (`Pk_id_chofer`);

--
-- Filtros para la tabla `tbl_vendedores`
--
ALTER TABLE `tbl_vendedores`
  ADD CONSTRAINT `tbl_vendedores_ibfk_1` FOREIGN KEY (`Fk_id_empleado`) REFERENCES `tbl_empleados` (`pk_clave`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
