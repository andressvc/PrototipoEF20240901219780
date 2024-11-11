using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Odbc;
using System.Data;

namespace CapaModelo_AndresVeron
{
    public class Sentencias
    {
        private Conexion conexion = new Conexion();

        // Método para insertar una nueva transacción
        public bool InsertarTransaccion(int idCliente, string fecha, string monto,
    string tipoMoneda, int estado, int idFactura, int idTransC, string tipo)
        {
            try
            {
                string sql = @"INSERT INTO Tbl_Transaccion_cliente 
        (Fk_id_cliente, transaccion_fecha, transaccion_monto, 
        transaccion_tipo_moneda, transaccion_estado, Fk_id_factura, 
        Fk_id_transC, transaccion_tipo) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sql, conn))
                    {
                        // Validación de fecha
                        if (!DateTime.TryParse(fecha, out DateTime fechaValida))
                        {
                            Console.WriteLine("Error: Formato de fecha inválido");
                            return false;
                        }

                        string fechaFormateada = fechaValida.ToString("yyyy-MM-dd");

                        // Añadir parámetros al comando
                        cmd.Parameters.Add(new OdbcParameter("@idCliente", idCliente));
                        cmd.Parameters.Add(new OdbcParameter("@fecha", fechaFormateada));
                        cmd.Parameters.Add(new OdbcParameter("@monto", monto));
                        cmd.Parameters.Add(new OdbcParameter("@tipoMoneda", tipoMoneda));
                        cmd.Parameters.Add(new OdbcParameter("@estado", estado));
                        cmd.Parameters.Add(new OdbcParameter("@idFactura", idFactura));
                        cmd.Parameters.Add(new OdbcParameter("@idTransC", idTransC));
                        cmd.Parameters.Add(new OdbcParameter("@tipo", tipo));

                        int result = cmd.ExecuteNonQuery();
                        return result > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error en InsertarTransaccion: {ex.Message}");
                return false;
            }
        }

        // Método para modificar una transacción existente
        public bool ModificarTransaccion(int idTransaccion, int idCliente, string fecha,
            string monto, string tipoMoneda, int estado, int idFactura, int idTransC, string tipo)
        {
            try
            {
                string sql = "UPDATE Tbl_transaccion_cliente SET " +
                    "Fk_id_cliente = ?, transaccion_fecha = ?, transaccion_monto = ?, " +
                    "transaccion_tipo_moneda = ?, transaccion_estado = ?, Fk_id_factura = ?, " +
                    "Fk_id_transC = ?, transaccion_tipo = ? " +
                    "WHERE Pk_id_transaccion = ?";

                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@idCliente", idCliente);
                        cmd.Parameters.AddWithValue("@fecha", fecha);
                        cmd.Parameters.AddWithValue("@monto", monto);
                        cmd.Parameters.AddWithValue("@tipoMoneda", tipoMoneda);
                        cmd.Parameters.AddWithValue("@estado", estado);
                        cmd.Parameters.AddWithValue("@idFactura", idFactura);
                        cmd.Parameters.AddWithValue("@idTransC", idTransC);
                        cmd.Parameters.AddWithValue("@tipo", tipo);
                        cmd.Parameters.AddWithValue("@idTransaccion", idTransaccion);

                        cmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en ModificarTransaccion: " + ex.Message);
                return false;
            }
        }

        // Método para eliminar una transacción
        public bool EliminarTransaccion(int idTransaccion)
        {
            try
            {
                string sql = "DELETE FROM Tbl_transaccion_cliente WHERE Pk_id_transaccion = ?";

                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@idTransaccion", idTransaccion);
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en EliminarTransaccion: " + ex.Message);
                return false;
            }
        }

        // Método para obtener todas las transacciones
        public DataTable ObtenerTransacciones()
        {
            DataTable dt = new DataTable();
            try
            {
                string sql = "SELECT * FROM Tbl_transaccion_cliente";
                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sql, conn))
                    {
                        OdbcDataAdapter da = new OdbcDataAdapter(cmd);
                        da.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en ObtenerTransacciones: " + ex.Message);
            }
            return dt;
        }

        // Método para obtener una transacción específica
        public DataTable ObtenerTransaccionPorId(int idTransaccion)
        {
            DataTable dt = new DataTable();
            try
            {
                string sql = "SELECT * FROM Tbl_transaccion_cliente WHERE Pk_id_transaccion = ?";
                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@idTransaccion", idTransaccion);
                        OdbcDataAdapter da = new OdbcDataAdapter(cmd);
                        da.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en ObtenerTransaccionPorId: " + ex.Message);
            }
            return dt;
        }
        public List<string> ObtenerClientesActivos()
        {
            List<string> clientes = new List<string>();
            string sQuery = "SELECT Pk_id_cliente FROM Tbl_Clientes WHERE estado = 1;";

            try
            {
                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sQuery, conn))
                    {
                        OdbcDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            clientes.Add(reader["Pk_id_cliente"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener clientes activos: {ex.Message}");
            }

            return clientes;
        }

        public List<string> ObtenerFactura()
        {
            List<string> factura = new List<string>();
            string sQuery = "SELECT Pk_id_factura FROM Tbl_factura;";

            try
            {
                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sQuery, conn))
                    {
                        OdbcDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            factura.Add(reader["Pk_id_factura"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener factura: {ex.Message}");
            }

            return factura;
        }

        public List<string> ObtenerEfecto()
        {
            List<string> efecto = new List<string>();
            string sQuery = "SELECT Pk_id_tran_cue FROM Tbl_transaccion_cuentas WHERE estado = 1;";

            try
            {
                using (OdbcConnection conn = conexion.conexion())
                {
                    using (OdbcCommand cmd = new OdbcCommand(sQuery, conn))
                    {
                        OdbcDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            efecto.Add(reader["Pk_id_tran_cue"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener factura: {ex.Message}");
            }

            return efecto;
        }
    }
}