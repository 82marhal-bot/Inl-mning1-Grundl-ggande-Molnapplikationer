param vmName string = 'MartinaMachine'
param location string = 'swedencentral'
param adminPublicKey string // Denna skickar du in via .parameters.json

// 1. Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: '${vmName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTP'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 320
          direction: 'Inbound'
        }
      }
    ]
  }
}

// 2. Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${vmName}-vnet'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '172.16.0.0/16' ] }
    subnets: [
      {
        name: 'default'
        properties: { addressPrefix: '172.16.0.0/24' }
      }
    ]
  }
}

// 3. Public IP
resource pip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${vmName}-ip'
  location: location
  sku: { name: 'Standard', tier: 'Regional' }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'martina-exam-unique' 
    }
  }
}

// 4. Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: pip.id }
          subnet: { id: vnet.properties.subnets[0].id }
        }
      }
    ]
    networkSecurityGroup: { id: nsg.id }
  }
}

// 5. Virtual Machine (Inklusive säkerhetsinställningar från portalen)
resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: 'Standard_B2ats_v2' }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Premium_LRS' }
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [ { path: '/home/azureuser/.ssh/authorized_keys', keyData: adminPublicKey } ]
        }
      }
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [ { id: nic.id } ]
    }
  }
}
