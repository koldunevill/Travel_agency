using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace Travel_agency
{
    /// <summary>
    /// Логика взаимодействия для AddClientWindow.xaml
    /// </summary>
    public partial class AddClientWindow : Window
    {
        private string tempPhotoPath = null;
        Клиенты oldclient = null;
        private string clientFolderPath = @"Client\";
        public AddClientWindow(Клиенты client)
        {
            InitializeComponent();
            if (client != null)
            {
                Familia.Text = client.Фамилия;
                Name.Text = client.Имя;
                Patronomyc.Text = client.Отчество;
                Pasport.Text = client.Паспортные_данные;
                DateBirth.SelectedDate = client.Дата_рождения;
                City.Text = client.Город;
                Adres.Text = client.Адрес;
                Phone.Text = client.Телефон;
                oldclient = client;
            }
            this.DataContext = client;
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            StringBuilder errors = new StringBuilder();

            if (string.IsNullOrEmpty(Familia.Text))
            {
                errors.AppendLine("Фамилия не может быть пустой.");
            }
            if (string.IsNullOrEmpty(Name.Text))
            {
                errors.AppendLine("Имя не может быть пустым.");
            }
            if (string.IsNullOrEmpty(Patronomyc.Text))
            {
                errors.AppendLine("Отчество не может быть пустым.");
            }
            if (string.IsNullOrEmpty(Pasport.Text) || Pasport.Text.Length != 10 || !Pasport.Text.All(char.IsDigit))
            {
                errors.AppendLine("Паспортные данные должны содержать 10 цифр.");
            }
            if (DateBirth.SelectedDate == null || DateBirth.SelectedDate > DateTime.Now.AddYears(-16))
            {
                errors.AppendLine("Дата рождения должна быть минимум 16 лет назад.");
            }
            if (string.IsNullOrEmpty(Phone.Text) || Phone.Text.Length != 11 || !Phone.Text.All(char.IsDigit))
            {
                errors.AppendLine("Номер телефона должен содержать 11 цифр.");
            }
            if (!(Phone.Text.StartsWith("7") || Phone.Text.StartsWith("8")))
            {
                errors.AppendLine("Номер телефона должен начинаться с 7, либо с 8.");
            }

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            try
            {
                if (oldclient != null)
                {
                    oldclient.Фамилия = Familia.Text;
                    oldclient.Имя = Name.Text;
                    oldclient.Отчество = Patronomyc.Text;
                    oldclient.Паспортные_данные = Pasport.Text;
                    oldclient.Дата_рождения = DateBirth.SelectedDate.Value;
                    oldclient.Город = City.Text;
                    oldclient.Адрес = Adres.Text;
                    oldclient.Телефон = Phone.Text;

                    if (tempPhotoPath != null)
                    {
                        oldclient.Фото = tempPhotoPath; 
                    }

                    Travel_agencyEntities.GetContext().SaveChanges(); 
                    MessageBox.Show("Данные клиента успешно обновлены!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    Клиенты newClient = new Клиенты
                    {
                        Фамилия = Familia.Text,
                        Имя = Name.Text,
                        Отчество = Patronomyc.Text,
                        Паспортные_данные = Pasport.Text,
                        Дата_рождения = DateBirth.SelectedDate.Value,
                        Город = City.Text,
                        Адрес = Adres.Text,
                        Телефон = Phone.Text
                    };

                    if (tempPhotoPath != null)
                    {
                        newClient.Фото = tempPhotoPath;
                    }

                    Travel_agencyEntities.GetContext().Клиенты.Add(newClient);
                    Travel_agencyEntities.GetContext().SaveChanges(); 
                    MessageBox.Show("Клиент успешно сохранен!", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                }

                this.Close(); 
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Произошла ошибка при сохранении: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void AddPhoto_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            if (openFileDialog.ShowDialog() == true)
            {
                string selectedFilePath = openFileDialog.FileName;

                tempPhotoPath = selectedFilePath;

                Фото.Source = new BitmapImage(new Uri(tempPhotoPath));
            }
        }
    }
}