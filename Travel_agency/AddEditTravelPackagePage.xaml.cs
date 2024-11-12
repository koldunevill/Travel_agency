using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Model;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace Travel_agency
{
    public partial class AddEditTravelPackagePage : Page
    {
        private Путевки currentPackage;
        private Клиенты currentClients;
        private Пансионаты пансионаты;
        private bool isSettingIndex = false;


        public AddEditTravelPackagePage(Путевки package = null)
        {
            InitializeComponent();
            UpdateClientList();
            currentPackage = package ?? new Путевки();
            ComboBoxPansionat.ItemsSource = Travel_agencyEntities.GetContext().Пансионаты.Select(f => f.Название).ToList();
            ComboBoxHousingType.ItemsSource = Travel_agencyEntities.GetContext().Виды_жилья.Select(f => f.Название).ToList();
            ComboBoxTour.ItemsSource = Travel_agencyEntities.GetContext().Туры.Select(f => f.Название).ToList();
            var clients = Travel_agencyEntities.GetContext().Клиенты.Select(c => new { ФИО = c.Фамилия + " " + c.Имя + " " + c.Отчество, Фото = c.Фото }).ToList();

            var clientsWithPhotoPath = clients.Select(c => new { ФИО = c.ФИО, ФотоПуть = !string.IsNullOrEmpty(c.Фото) ? (System.IO.Path.IsPathRooted(c.Фото) ? c.Фото : System.IO.Path.Combine("", c.Фото)) : string.Empty }).ToList();

            clientsWithPhotoPath.Insert(0, new { ФИО = "-", ФотоПуть = string.Empty });
            SelectCLient.ItemsSource = clientsWithPhotoPath;
            if (currentPackage.ID_Вид_жилья == null)
            {
                ComboBoxHousingType.Visibility = Visibility.Collapsed;
            }
            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromMilliseconds(10);
            timer.Tick += (s, e) =>
            {
                if (currentPackage.ID_Путевки == 0)
                {
                    SelectCLient.SelectedIndex = 0;
                }
                else
                {
                    if (currentPackage.ID_Пансионата != null)
                    {
                        ComboBoxPansionat.SelectedIndex = (int)currentPackage.ID_Пансионата - 1;
                        ComboBoxHousingType.SelectedIndex = (int)currentPackage.ID_Вид_жилья - 1;
                        ComboBoxTour.Visibility = Visibility.Collapsed;
                    }
                    else
                    {
                        ComboBoxTour.SelectedIndex = (int)currentPackage.ID_Тура - 1;
                        ComboBoxHousingType.Visibility = Visibility.Collapsed;
                        ComboBoxPansionat.Visibility = Visibility.Collapsed;
                    }
                    SelectCLient.SelectedIndex = currentPackage.ID_Клиента;


                    ArrivalDatePicker.SelectedDate = currentPackage.Дата_заезда;
                    DepartureDatePicker.SelectedDate = currentPackage.Дата_отъезда;
                    PeopleCountTextBox.Text = currentPackage.Количество_человек.ToString();
                    PriceTextBox.Text = currentPackage.Цена.ToString();
                    ChildrenCheckBox.IsChecked = currentPackage.Наличие_детей;
                    InsuranceCheckBox.IsChecked = currentPackage.Наличие_мед__страховки;


                }
                timer.Stop();
            };
            timer.Start();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            var errorMessages = new StringBuilder();

            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                currentPackage.ID_Пансионата = ComboBoxPansionat.SelectedIndex + 1;
                currentPackage.ID_Вид_жилья = ComboBoxHousingType.SelectedIndex + 1;
                currentPackage.ID_Тура = null;
            }
            else if (ComboBoxTour.SelectedIndex != -1)
            {
                currentPackage.ID_Тура = ComboBoxTour.SelectedIndex + 1;
                currentPackage.ID_Пансионата = null;
                currentPackage.ID_Вид_жилья = null;
            }
            else
            {
                errorMessages.AppendLine("Пожалуйста, выберите пансионат или тур.");
            }

            if (!ArrivalDatePicker.SelectedDate.HasValue || !DepartureDatePicker.SelectedDate.HasValue)
            {
                errorMessages.AppendLine("Пожалуйста, выберите даты заезда и отъезда.");
            }
            else if (ArrivalDatePicker.SelectedDate.Value >= DepartureDatePicker.SelectedDate.Value)
            {
                errorMessages.AppendLine("Дата заезда должна быть раньше даты отъезда.");
            }

            if (string.IsNullOrEmpty(PeopleCountTextBox.Text) || !int.TryParse(PeopleCountTextBox.Text, out int peopleCount) ||
                peopleCount < 1 || peopleCount > 4)
            {
                errorMessages.AppendLine("Пожалуйста, укажите количество человек от 1 до 4.");
            }

            if (string.IsNullOrEmpty(PriceTextBox.Text) || !decimal.TryParse(PriceTextBox.Text, out decimal price))
            {
                errorMessages.AppendLine("Пожалуйста, укажите корректную цену.");
            }
            if (errorMessages.Length > 0)
            {
                MessageBox.Show(errorMessages.ToString());
                return;
            }

            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                currentPackage.ID_Пансионата = ComboBoxPansionat.SelectedIndex + 1;
                currentPackage.ID_Вид_жилья = ComboBoxHousingType.SelectedIndex + 1;
                currentPackage.ID_Тура = null;
            }
            else if (ComboBoxTour.SelectedIndex != -1)
            {
                currentPackage.ID_Тура = ComboBoxTour.SelectedIndex + 1;
                currentPackage.ID_Пансионата = null;
                currentPackage.ID_Вид_жилья = null;
            }
            currentPackage.ID_Клиента = SelectCLient.SelectedIndex;
            currentPackage.Дата_заезда = ArrivalDatePicker.SelectedDate.Value;
            currentPackage.Дата_отъезда = DepartureDatePicker.SelectedDate.Value;
            currentPackage.Количество_человек = int.Parse(PeopleCountTextBox.Text);
            currentPackage.Цена = decimal.Parse(PriceTextBox.Text);
            currentPackage.Наличие_детей = ChildrenCheckBox.IsChecked ?? false;
            currentPackage.Наличие_мед__страховки = InsuranceCheckBox.IsChecked ?? false;

            if (currentPackage.ID_Путевки == 0)
            {
                Travel_agencyEntities.GetContext().Путевки.Add(currentPackage);
            }

            Travel_agencyEntities.GetContext().SaveChanges();

            MessageBox.Show("Путевка успешно сохранена.");
            manager.MainFrame.GoBack();
        }


        private void SelectCLient_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (SelectCLient.SelectedIndex == 0)
            {
                AddClient.Content = "Добавить";
            }
            else
            {
                AddClient.Content = "Редактировать";
            }
        }

        private void GoBack_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.GoBack();
        }

        private void ComboBoxPansionat_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                int selectedPansionatId = ComboBoxPansionat.SelectedIndex + 1;

                var housingTypes = Travel_agencyEntities.GetContext()
                                   .Виды_жилья
                                   .Where(h => h.ID_Пансионата == selectedPansionatId)
                                   .Select(h => h.Название)
                                   .ToList();

                ComboBoxHousingType.ItemsSource = housingTypes;

                ComboBoxHousingType.Visibility = housingTypes.Any() ? Visibility.Visible : Visibility.Collapsed;

                ComboBoxTour.Visibility = Visibility.Collapsed;
            }
            else
            {
                ComboBoxHousingType.Visibility = Visibility.Collapsed;
            }

        }

        private void ComboBoxHousingType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxHousingType.SelectedIndex != -1)
            {
                ComboBoxTour.Visibility = Visibility.Collapsed;
            }
        }

        private void ComboBoxTour_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxTour.SelectedIndex != -1)
            {
                ComboBoxHousingType.Visibility = Visibility.Collapsed;
                ComboBoxPansionat.Visibility = Visibility.Collapsed;
            }
        }

        private void AddClient_Click(object sender, RoutedEventArgs e)
        {
            AddClientWindow addclient;
            if (SelectCLient.SelectedIndex != 0)
            {
                Клиенты client = Travel_agencyEntities.GetContext().Клиенты.FirstOrDefault(f => f.ID_Клиента == SelectCLient.SelectedIndex);
                addclient = new AddClientWindow(client);
                addclient.Show();
            }
            else
            {
                addclient = new AddClientWindow(null);
                addclient.Show();
            }
            addclient.Closed += (s, args) => UpdateClientList();
            addclient.Show();
        }
        private void UpdateClientList()
        {
            var clients = Travel_agencyEntities.GetContext().Клиенты.Select(c => new{ФИО = c.Фамилия + " " + c.Имя + " " + c.Отчество,Фото = c.Фото}).ToList();

            var clientsWithPhotoPath = clients.Select(c => new{ФИО = c.ФИО, ФотоПуть = !string.IsNullOrEmpty(c.Фото)? (System.IO.Path.IsPathRooted(c.Фото)? c.Фото : System.IO.Path.Combine("", c.Фото))  : string.Empty} ).ToList();

            clientsWithPhotoPath.Insert(0, new { ФИО = "-", ФотоПуть = string.Empty });

            SelectCLient.ItemsSource = clientsWithPhotoPath;
        }
    }
}

