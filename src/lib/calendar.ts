
export interface CalendarEvent {
  title: string;
  description: string;
  location: string;
  startTime: string; // ISO string or YYYY-MM-DDTHH:mm:ss
  endTime: string;   // ISO string or YYYY-MM-DDTHH:mm:ss
}

export const generateGoogleCalendarUrl = (event: CalendarEvent): string => {
  const start = event.startTime.replace(/[-:]/g, '').split('.')[0] + 'Z';
  const end = event.endTime.replace(/[-:]/g, '').split('.')[0] + 'Z';
  
  const params = new URLSearchParams({
    action: 'TEMPLATE',
    text: event.title,
    dates: `${start}/${end}`,
    details: event.description,
    location: event.location,
  });

  return `https://www.google.com/calendar/render?${params.toString()}`;
};

export const downloadIcsFile = (event: CalendarEvent) => {
  const start = event.startTime.replace(/[-:]/g, '').split('.')[0] + 'Z';
  const end = event.endTime.replace(/[-:]/g, '').split('.')[0] + 'Z';

  const icsContent = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'BEGIN:VEVENT',
    `DTSTART:${start}`,
    `DTEND:${end}`,
    `SUMMARY:${event.title}`,
    `DESCRIPTION:${event.description}`,
    `LOCATION:${event.location}`,
    'END:VEVENT',
    'END:VCALENDAR'
  ].join('\n');

  const blob = new Blob([icsContent], { type: 'text/calendar;charset=utf-8' });
  const url = window.URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `${event.title.replace(/\s+/g, '_')}.ics`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
