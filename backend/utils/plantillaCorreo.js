// Plantilla HTML compartida para los correos con código de Asadero La Ceiba.
// Usa tablas y estilos en línea para que se vea igual en Gmail, Outlook, etc.

// Evitar que caracteres especiales dañen el HTML del correo.
export const escaparHtml = (texto) => {
    return String(texto ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
};

export const plantillaCodigo = ({
    titulo,
    nombre,
    mensaje,
    codigo,
    aviso,
    minutos = 10
}) => `
<div style="background:#f4f1ea;padding:24px 12px;font-family:Arial,Helvetica,sans-serif;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0"
    style="max-width:520px;margin:0 auto;background:#ffffff;border:1px solid #eadfc0;border-radius:16px;overflow:hidden;">
    <tr>
      <td align="center" style="background:#7B1103;padding:28px 16px;">
        <span style="color:#F8ECAC;font-size:24px;font-weight:bold;">Asadero La Ceiba</span>
      </td>
    </tr>
    <tr>
      <td align="center" style="padding:32px 28px 8px;">
        <h2 style="margin:0 0 16px;color:#1C0A0A;font-size:22px;">${titulo}</h2>
        <p style="margin:0 0 8px;color:#555555;font-size:15px;line-height:1.5;">
          Hola <strong>${escaparHtml(nombre)}</strong>,
        </p>
        <p style="margin:0 0 24px;color:#555555;font-size:15px;line-height:1.5;">${mensaje}</p>
        <div style="display:inline-block;background:#FFF8E1;border:2px dashed #B81202;border-radius:12px;padding:16px 18px 16px 28px;">
          <span style="color:#B81202;font-size:34px;font-weight:bold;letter-spacing:10px;">${escaparHtml(codigo)}</span>
        </div>
        <p style="margin:24px 0 4px;color:#777777;font-size:13px;">
          Este código es válido durante <strong>${minutos} minutos</strong>.
        </p>
        <p style="margin:0 0 24px;color:#777777;font-size:13px;">${aviso}</p>
      </td>
    </tr>
    <tr>
      <td align="center" style="background:#faf6e8;padding:16px;color:#999999;font-size:12px;">
        © ${new Date().getFullYear()} Asadero La Ceiba
      </td>
    </tr>
  </table>
</div>
`;