# esx_vehicleshopvip

The `esx_vehicleshopvip` is an extension of the standard ESX Vehicle Shop, designed to offer a premium experience for VIP players. This system allows VIP players to purchase exclusive vehicles using VIP coins, which can be managed by server administrators.

## Requirements

- **ESX Framework**: Ensure that your server is running the ESX framework.
- **MySQL Database**: Required for storing vehicle and player data.
- **VIP Coin System**: A system to manage VIP coins for players.

## Installation

### Using Git

1. Navigate to your resources directory:
   ```bash
   cd resources
   ```
2. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/esx_vehicleshopvip [esx]/esx_vehicleshopvip
   ```

### Manually

1. Download the repository as a ZIP file.
2. Extract the contents to the `[esx]` directory in your resources folder.

### Database

- Import `esx_vehicleshopvip.sql` into your MySQL database to set up the necessary tables.

### Configuration

- Open `config.lua` in the `esx_vehicleshopvip` folder to configure the shop's settings, such as the location, vehicle categories, and VIP coin settings.

### Server Configuration

- Add the following line to your `server.cfg` to start the resource:
  ```plaintext
  start esx_vehicleshopvip
  ```

## Usage

- **VIP Coin Management**: Administrators can use the `/givevipcoin` command to add VIP coins to players.
- **Purchasing Vehicles**: VIP players can access the shop to purchase exclusive vehicles using their VIP coins.

## Legal

### License

`esx_vehicleshopvip` - VIP vehicle shop for ESX

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).
