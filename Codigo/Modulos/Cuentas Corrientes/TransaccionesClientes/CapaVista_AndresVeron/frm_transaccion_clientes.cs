using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;


namespace CapaVista_AndresVeron
{
    public partial class frm_transaccion_clientes : Form
    {
        public CapaControlador_AndresVeron.Controlador cn = new CapaControlador_AndresVeron.Controlador();

        public frm_transaccion_clientes()
        {
            InitializeComponent();
            CargarDatosGrid();
            cargarClientes();
            cargarFactura();
            cargarEfecto();



            // Establecer el estado inicial de los botones
            btn_editar_trans.Enabled = false;
            btn_eliminar_trans.Enabled = false;
        }

        private void frm_transaccion_clientes_Load(object sender, EventArgs e)
        {
          
        }
        private void CargarDatosGrid()
        {
            // Cargar datos al DataGridView
            dgv_transaccion_cliente.DataSource = cn.ObtenerTransacciones();
            FormatearGrid();
        }

        private void FormatearGrid()
        {
            // Configurar las columnas del DataGridView
            dgv_transaccion_cliente.Columns["Pk_id_transaccion"].HeaderText = "ID";
            dgv_transaccion_cliente.Columns["Fk_id_cliente"].HeaderText = "Cliente ID";
            dgv_transaccion_cliente.Columns["transaccion_fecha"].HeaderText = "Fecha";
            dgv_transaccion_cliente.Columns["transaccion_monto"].HeaderText = "Monto";
            dgv_transaccion_cliente.Columns["transaccion_tipo_moneda"].HeaderText = "Moneda";
            dgv_transaccion_cliente.Columns["transaccion_estado"].HeaderText = "Estado";
            dgv_transaccion_cliente.Columns["Fk_id_factura"].HeaderText = "Factura ID";
            dgv_transaccion_cliente.Columns["Fk_id_transC"].HeaderText = "Trans. Cuenta ID";
            dgv_transaccion_cliente.Columns["transaccion_tipo"].HeaderText = "Tipo";
        }

        private void LimpiarCampos()
        {
            txt_Idtrans.Clear();
            cbo_cliente_transcl.SelectedIndex = -1;
            txt_fechatrans.Clear();
            txt_transmonto.Clear();
            cbo_moneda_tarnscl.SelectedIndex = -1;
            cbo_estado_transcl.SelectedIndex = -1;
            cbo_tipo_transcl.SelectedIndex = -1;
            cbo_fac_transcl.SelectedIndex = -1;
            cbo_cuenta_transcl.SelectedIndex = -1;

            btn_guardar_trans.Enabled = true;
            btn_editar_trans.Enabled = false;
            btn_eliminar_trans.Enabled = false;
        }
        // Evento del botón Guardar
        private void btn_guardar_trans_Click(object sender, EventArgs e)
        {
            try
            {
                if (ValidarCampos())
                {
                    // Validar que los ComboBox no estén vacíos
                    if (string.IsNullOrEmpty(cbo_cliente_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_moneda_tarnscl.Text) ||
                        string.IsNullOrEmpty(cbo_estado_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_fac_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_cuenta_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_tipo_transcl.Text))
                    {
                        MessageBox.Show("Por favor, complete todos los campos requeridos.", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        return;
                    }

                    // Convertir y validar los valores antes de enviarlos
                    int idCliente = Convert.ToInt32(cbo_cliente_transcl.SelectedValue); // Usar SelectedValue para obtener el ID
                    string fecha = txt_fechatrans.Text.Trim();
                    string monto = txt_transmonto.Text.Trim();

                    // Validar que monto sea un valor numérico
                    if (!decimal.TryParse(monto, out _))
                    {
                        MessageBox.Show("El monto debe ser un valor numérico válido", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    string moneda = cbo_moneda_tarnscl.Text.Trim();
                    int estado = Convert.ToInt32(cbo_estado_transcl.SelectedValue); // Usar SelectedValue
                    int idFactura = Convert.ToInt32(cbo_fac_transcl.SelectedValue); // Usar SelectedValue
                    int idTransC = Convert.ToInt32(cbo_cuenta_transcl.SelectedValue); // Usar SelectedValue
                    string tipo = cbo_tipo_transcl.Text.Trim();

                    // Insertar la transacción con monto como string
                    bool resultado = cn.InsertarTransaccion(
                        idCliente, fecha, monto, moneda, estado,
                        idFactura, idTransC, tipo
                    );

                    if (resultado)
                    {
                        MessageBox.Show("Transacción guardada exitosamente", "Éxito",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
                        CargarDatosGrid();
                        LimpiarCampos();
                    }
                    else
                    {
                        MessageBox.Show("No se pudo guardar la transacción", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al guardar: " + ex.Message, "Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // Evento del botón Editar
        private void btn_editar_trans_Click(object sender, EventArgs e)
        {
            try
            {
                if (ValidarCampos() && !string.IsNullOrEmpty(txt_Idtrans.Text))
                {
                    // Validar que los ComboBox no estén vacíos
                    if (string.IsNullOrEmpty(cbo_cliente_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_moneda_tarnscl.Text) ||
                        string.IsNullOrEmpty(cbo_estado_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_fac_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_cuenta_transcl.Text) ||
                        string.IsNullOrEmpty(cbo_tipo_transcl.Text))
                    {
                        MessageBox.Show("Por favor, complete todos los campos requeridos.", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        return;
                    }

                    // Convertir y validar los valores antes de enviarlos
                    int idTransaccion = Convert.ToInt32(txt_Idtrans.Text.Trim());
                    int idCliente = Convert.ToInt32(cbo_cliente_transcl.SelectedValue); // Usar SelectedValue para obtener el ID
                    string fecha = txt_fechatrans.Text.Trim();
                    string monto = txt_transmonto.Text.Trim();

                    // Validar que monto sea un valor numérico
                    if (!decimal.TryParse(monto, out _))
                    {
                        MessageBox.Show("El monto debe ser un valor numérico válido", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    string moneda = cbo_moneda_tarnscl.Text.Trim();
                    int estado = Convert.ToInt32(cbo_estado_transcl.SelectedValue); // Usar SelectedValue
                    int idFactura = Convert.ToInt32(cbo_fac_transcl.SelectedValue); // Usar SelectedValue
                    int idTransC = Convert.ToInt32(cbo_cuenta_transcl.SelectedValue); // Usar SelectedValue
                    string tipo = cbo_tipo_transcl.Text.Trim();

                    // Modificar la transacción con monto como string
                    bool resultado = cn.ModificarTransaccion(
                        idTransaccion, idCliente, fecha, monto, moneda,
                        estado, idFactura, idTransC, tipo
                    );

                    if (resultado)
                    {
                        MessageBox.Show("Transacción modificada exitosamente", "Éxito",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
                        CargarDatosGrid();
                        LimpiarCampos();
                    }
                    else
                    {
                        MessageBox.Show("No se pudo modificar la transacción", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al modificar: " + ex.Message, "Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // Evento del botón Eliminar
        private void btn_eliminar_trans_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(txt_Idtrans.Text))
                {
                    if (MessageBox.Show("¿Está seguro de eliminar esta transacción?", "Confirmar eliminación",
                        MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    {
                        bool resultado = cn.EliminarTransaccion(Convert.ToInt32(txt_Idtrans.Text));
                        if (resultado)
                        {
                            MessageBox.Show("Transacción eliminada exitosamente", "Éxito",
                                MessageBoxButtons.OK, MessageBoxIcon.Information);
                            CargarDatosGrid();
                            LimpiarCampos();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al eliminar: " + ex.Message, "Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // Evento del botón Buscar
        private void btn_buscar_trans_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(txt_Idtrans.Text))
                {
                    DataTable dt = cn.ObtenerTransaccionPorId(Convert.ToInt32(txt_Idtrans.Text));
                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        cbo_tipo_transcl.Text = row["Fk_id_cliente"].ToString();
                        txt_fechatrans.Text = row["transaccion_fecha"].ToString();
                        txt_transmonto.Text = row["transaccion_monto"].ToString();
                        cbo_moneda_tarnscl.Text = row["transaccion_tipo_moneda"].ToString();
                        cbo_estado_transcl.Text = row["transaccion_estado"].ToString();
                        cbo_tipo_transcl.Text = row["transaccion_tipo"].ToString();
                        cbo_fac_transcl.Text = row["Fk_id_factura"].ToString();
                        cbo_cuenta_transcl.Text = row["Fk_id_transC"].ToString();

                        btn_guardar_trans.Enabled = false;
                        btn_editar_trans.Enabled = true;
                        btn_eliminar_trans.Enabled = true;
                    }
                    else
                    {
                        MessageBox.Show("No se encontró la transacción", "Información",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
                        LimpiarCampos();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al buscar: " + ex.Message, "Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrEmpty(cbo_cliente_transcl.Text) ||
                string.IsNullOrEmpty(txt_fechatrans.Text) ||
                string.IsNullOrEmpty(txt_transmonto.Text) ||
                string.IsNullOrEmpty(cbo_moneda_tarnscl.Text) ||
                string.IsNullOrEmpty(cbo_estado_transcl.Text) ||
                string.IsNullOrEmpty(cbo_tipo_transcl.Text) ||
                string.IsNullOrEmpty(cbo_fac_transcl.Text) ||
                string.IsNullOrEmpty(cbo_cuenta_transcl.Text))
            {
                MessageBox.Show("Todos los campos son obligatorios", "Validación",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
            return true;
        }


        private void dgv_transaccion_cliente_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dgv_transaccion_cliente.Rows[e.RowIndex];
                txt_Idtrans.Text = row.Cells["Pk_id_transaccion"].Value.ToString();
                cbo_cliente_transcl.Text = row.Cells["Fk_id_cliente"].Value.ToString();
                txt_fechatrans.Text = row.Cells["transaccion_fecha"].Value.ToString();
                txt_transmonto.Text = row.Cells["transaccion_monto"].Value.ToString();
                cbo_moneda_tarnscl.Text = row.Cells["transaccion_tipo_moneda"].Value.ToString();
                cbo_estado_transcl.Text = row.Cells["transaccion_estado"].Value.ToString();
                cbo_tipo_transcl.Text = row.Cells["transaccion_tipo"].Value.ToString();
                cbo_fac_transcl.Text = row.Cells["Fk_id_factura"].Value.ToString();
                cbo_cuenta_transcl.Text = row.Cells["Fk_id_transC"].Value.ToString();

                btn_guardar_trans.Enabled = false;
                btn_editar_trans.Enabled = true;
                btn_eliminar_trans.Enabled = true;
            }

        }

        public void ConfigurarDataGridView()
        {
            dgv_transaccion_cliente.ReadOnly = true;
            dgv_transaccion_cliente.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgv_transaccion_cliente.AllowUserToAddRows = false;
            dgv_transaccion_cliente.AllowUserToDeleteRows = false;
            dgv_transaccion_cliente.AllowUserToResizeColumns = false;
            dgv_transaccion_cliente.AllowUserToResizeRows = false;
        }


        private void btn_reporte_Click(object sender, EventArgs e)
        {
            frm_reportretrans_cliente formulario = new frm_reportretrans_cliente();  
            formulario.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_ayudatransclientes_Click(object sender, EventArgs e)
        {
            try
            {
                // Buscar la carpeta raíz del proyecto (donde está la carpeta "Codigo")
                string executablePath = AppDomain.CurrentDomain.BaseDirectory;
                string projectRoot = executablePath;

                // Buscar hacia arriba hasta encontrar la carpeta "Codigo"
                while (!Directory.Exists(Path.Combine(projectRoot, "Codigo")) &&
                       Directory.GetParent(projectRoot) != null)
                {
                    projectRoot = Directory.GetParent(projectRoot).FullName;
                }

                // Construir la ruta a la carpeta de ayuda
                string ayudaFolderPath = Path.Combine(projectRoot,
                    "Codigo", "Modulos", "Cuentas Corrientes", "TransaccionesClientes", "AyudasTCL"); //"Codigo", "Modulos", "Cuentas Corrientes", "TransaccionesClientes", "Ayudas" asi debe quedar integrado

                //  MessageBox.Show("Ruta de búsqueda: " + ayudaFolderPath);

                // Busca el archivo .chm en la carpeta especificada
                string pathAyuda = FindFileInDirectory(ayudaFolderPath, "AyudaTCL.chm");

                if (!string.IsNullOrEmpty(pathAyuda))
                {
                    Help.ShowHelp(null, pathAyuda, "ayudastransclientes.html");
                }
                else
                {
                    MessageBox.Show("El archivo de ayuda no se encontró.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al buscar el archivo de ayuda: " + ex.Message);
            }
        }
        private string FindFileInDirectory(string directory, string fileName)
        {
            try
            {
                // Verificamos si la carpeta existe
                if (Directory.Exists(directory))
                {
                    // Buscamos el archivo .chm en la carpeta
                    string[] files = Directory.GetFiles(directory, "*.chm", SearchOption.TopDirectoryOnly);
                    // Si encontramos el archivo, verificamos si coincide con el archivo que se busca y retornamos su ruta
                    foreach (var file in files)
                    {
                        if (Path.GetFileName(file).Equals(fileName, StringComparison.OrdinalIgnoreCase))
                        {
                            //MessageBox.Show("Archivo encontrado: " + file);
                            return file;
                        }
                    }
                }
                else
                {
                    MessageBox.Show("No se encontró la carpeta: " + directory);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al buscar el archivo: " + ex.Message);
            }
            // Retorna null si no se encontró el archivo
            return null;
        }





        private void txt_fac_transcl_TextChanged(object sender, EventArgs e)
        {

        }

        private void txt_Idtrans_TextChanged(object sender, EventArgs e)
        {

        }

        private void txt_Idtrans_KeyPress(object sender, KeyPressEventArgs e)
        {

            if ((e.KeyChar >= 32 && e.KeyChar <= 47) || (e.KeyChar >= 58 && e.KeyChar <= 255))
            {
                MessageBox.Show("Solo números", "Alerta", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                e.Handled = true;
                return;
            }
        }

        private void txt_estadotrans_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((e.KeyChar >= 32 && e.KeyChar <= 47) || (e.KeyChar >= 58 && e.KeyChar <= 255))
            {
                MessageBox.Show("Solo números", "Alerta", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                e.Handled = true;
                return;
            }
        }

        private void txt_transmonto_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((e.KeyChar >= 32 && e.KeyChar <= 47) || (e.KeyChar >= 58 && e.KeyChar <= 255))
            {
                MessageBox.Show("Solo números", "Alerta", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                e.Handled = true;
                return;
            }
        }

        private void cbo_cliente_transcl_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

        private void cargarClientes()
        {
            List<string> limpiarComboBox = new List<string>();
            cbo_cliente_transcl.DataSource = limpiarComboBox; 

            List<string> clientesActivos = cn.ListadoClientesActivos();
            cbo_cliente_transcl.DataSource = clientesActivos; 
        }

        private void cargarFactura()
        {
            List<string> limpiarComboBox = new List<string>();
            cbo_fac_transcl.DataSource = limpiarComboBox;

            List<string> clientesActivos = cn.FormaFactura();
            cbo_fac_transcl.DataSource = clientesActivos;
        }

        private void cargarEfecto()
        {
            List<string> limpiarComboBox = new List<string>();
           cbo_cuenta_transcl.DataSource = limpiarComboBox;

            List<string> clientesActivos = cn.ListadoEfecto();
           cbo_cuenta_transcl.DataSource = clientesActivos;
        }

    }
}

