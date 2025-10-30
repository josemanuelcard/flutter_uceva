import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user.dart';

/// Pantalla de evidencia que muestra los datos almacenados localmente
class EvidenciaLocalScreen extends StatefulWidget {
  const EvidenciaLocalScreen({super.key});

  @override
  State<EvidenciaLocalScreen> createState() => _EvidenciaLocalScreenState();
}

class _EvidenciaLocalScreenState extends State<EvidenciaLocalScreen> {
  Map<String, dynamic>? _authInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthInfo();
  }

  /// Cargar información de autenticación
  Future<void> _loadAuthInfo() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final authInfo = await authController.getAuthInfo();
    
    setState(() {
      _authInfo = authInfo;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Evidencia Local'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAuthInfo,
            tooltip: 'Actualizar información',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  /// Construir contenido principal
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de información del usuario
          _buildUserInfoCard(),
          const SizedBox(height: 16),
          
          // Tarjeta de estado del token
          _buildTokenStatusCard(),
          const SizedBox(height: 16),
          
          // Tarjeta de información adicional
          _buildAdditionalInfoCard(),
          const SizedBox(height: 24),
          
          // Botón de cerrar sesión
          _buildLogoutButton(),
        ],
      ),
    );
  }

  /// Tarjeta con información del usuario
  Widget _buildUserInfoCard() {
    final user = _authInfo?['user'] as User?;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información del Usuario',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (user != null) ...[
              _buildInfoRow('ID', user.id.toString()),
              _buildInfoRow('Nombre', user.name),
              _buildInfoRow('Email', user.email),
              if (user.phone != null) _buildInfoRow('Teléfono', user.phone!),
              if (user.createdAt != null) 
                _buildInfoRow('Fecha de registro', _formatDate(user.createdAt!)),
            ] else ...[
              const Text(
                'No hay información de usuario disponible',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Tarjeta con estado del token
  Widget _buildTokenStatusCard() {
    final hasToken = _authInfo?['hasToken'] as bool? ?? false;
    final token = _authInfo?['token'] as String?;
    final tokenType = _authInfo?['tokenType'] as String?;
    final isExpired = _authInfo?['isExpired'] as bool? ?? true;
    final expiration = _authInfo?['expiration'] as DateTime?;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado del Token',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Estado del token
            Row(
              children: [
                Icon(
                  hasToken ? Icons.check_circle : Icons.cancel,
                  color: hasToken ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  hasToken ? '✅ Token presente' : '❌ Sin token',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hasToken ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
            
            if (hasToken) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Tipo de token', tokenType ?? 'Bearer'),
              _buildInfoRow('Token (primeros 20 caracteres)', 
                token != null ? '${token.substring(0, 20)}...' : 'N/A'),
              _buildInfoRow('Estado', isExpired ? 'Expirado' : 'Válido'),
              if (expiration != null) 
                _buildInfoRow('Expira', _formatDate(expiration)),
            ],
          ],
        ),
      ),
    );
  }

  /// Tarjeta con información adicional
  Widget _buildAdditionalInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información Adicional',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow('Datos en SharedPreferences', 
              _authInfo?['user'] != null ? 'Presentes' : 'No disponibles'),
            _buildInfoRow('Token en Secure Storage', 
              _authInfo?['hasToken'] == true ? 'Presente' : 'No disponible'),
            _buildInfoRow('Última actualización', _formatDate(DateTime.now())),
          ],
        ),
      ),
    );
  }

  /// Botón de cerrar sesión
  Widget _buildLogoutButton() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: authController.isLoading ? null : _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            icon: authController.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.logout),
            label: Text(
              authController.isLoading ? 'Cerrando sesión...' : 'Cerrar Sesión',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construir fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formatear fecha
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Manejar cierre de sesión
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión? '
          'Se eliminarán todos los datos almacenados localmente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final authController = Provider.of<AuthController>(context, listen: false);
              await authController.logout();
              
              // Recargar información
              await _loadAuthInfo();
              
              // Mostrar mensaje de confirmación
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
